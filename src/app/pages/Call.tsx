import { useEffect, useRef, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router';
import { PhoneOff, Mic, MicOff, Video, VideoOff, Volume2, VolumeX, MonitorUp, MonitorOff } from 'lucide-react';
import { useAuth } from '../../lib/AuthContext';
import { initiateCall, acceptCall, endCall, listenCall, CallDoc } from '../../lib/callSignaling';
import { createPC, setupCallerSignaling, setupReceiverSignaling, cleanupCallData } from '../../lib/webrtcCall';

export default function Call() {
  const navigate = useNavigate();
  const [params] = useSearchParams();
  const { user: currentUser } = useAuth();

  const receiverId   = params.get('userId')   || '';
  const receiverName = params.get('userName') || 'User';
  const type         = (params.get('type')    || 'video') as 'audio' | 'video';
  const incomingCallId = params.get('callId') || '';
  const isCaller = !incomingCallId;

  const localVideoRef  = useRef<HTMLVideoElement>(null);
  const remoteVideoRef = useRef<HTMLVideoElement>(null);
  const remoteAudioRef = useRef<HTMLAudioElement>(null);
  const pcRef          = useRef<RTCPeerConnection | null>(null);
  const localStreamRef = useRef<MediaStream | null>(null);
  const startedRef     = useRef(false);
  const hangingUpRef   = useRef(false); // prevent double hangup

  const [callId,   setCallId]   = useState('');
  const [callData, setCallData] = useState<CallDoc | null>(null);
  const [status,   setStatus]   = useState<'calling'|'connecting'|'connected'|'declined'>('calling');
  const [muted,       setMuted]       = useState(false);
  const [videoOff,    setVideoOff]    = useState(false);
  const [speakerOn,   setSpeakerOn]   = useState(true);
  const [hasRemote,   setHasRemote]   = useState(false);
  const [sharing,     setSharing]     = useState(false);
  const [shareError,  setShareError]  = useState('');
  const screenStreamRef = useRef<MediaStream | null>(null);

  const displayName = isCaller ? receiverName : (callData?.callerName || 'User');

  // ── Step 1: create / join signaling doc ─────────────────────────────────────
  useEffect(() => {
    if (!currentUser) return;
    if (isCaller) {
      initiateCall(
        currentUser.uid,
        currentUser.displayName || currentUser.email || 'User',
        receiverId, receiverName, type
      ).then(({ id }) => setCallId(id));
    } else {
      setCallId(incomingCallId);
      acceptCall(incomingCallId);
    }
  }, [currentUser]);

  // ── Step 2: watch signaling doc ──────────────────────────────────────────────
  useEffect(() => {
    if (!callId || !currentUser) return;
    const unsub = listenCall(callId, (data) => {
      if (!data) {
        // Doc deleted by other side — leave quietly
        if (!hangingUpRef.current) leaveCall(false);
        return;
      }
      setCallData(data);

      if (isCaller && data.status === 'declined') {
        setStatus('declined');
        setTimeout(() => leaveCall(false), 2000);
        return;
      }

      const shouldStart =
        (isCaller  && data.status === 'accepted') ||
        (!isCaller && (data.status === 'accepted' || data.status === 'calling'));

      if (shouldStart && !startedRef.current) {
        startedRef.current = true;
        startWebRTC(callId);
      }
    });
    return unsub;
  }, [callId, currentUser]);

  // ── 30 s no-answer timeout ───────────────────────────────────────────────────
  useEffect(() => {
    if (!isCaller || !callId) return;
    const t = setTimeout(() => {
      if (!startedRef.current) hangUp();
    }, 30000);
    return () => clearTimeout(t);
  }, [callId]);

  // ── WebRTC setup ─────────────────────────────────────────────────────────────
  async function startWebRTC(id: string) {
    setStatus('connecting');

    // Get local media — try strict then lenient then audio-only
    let stream: MediaStream | null = null;
    for (const constraints of [
      { audio: true, video: type === 'video' ? { facingMode: { ideal: 'user' } } : false },
      { audio: true, video: type === 'video' },
      { audio: true, video: false },
    ]) {
      try {
        stream = await navigator.mediaDevices.getUserMedia(constraints);
        break;
      } catch { /* try next */ }
    }

    if (!stream) {
      console.warn('getUserMedia failed — continuing without local media');
    } else {
      localStreamRef.current = stream;
      if (localVideoRef.current) localVideoRef.current.srcObject = stream;
    }

    const pc = createPC();
    pcRef.current = pc;

    // ontrack must be wired BEFORE signaling
    pc.ontrack = (e) => {
      const s = e.streams[0];
      if (remoteVideoRef.current) {
        remoteVideoRef.current.srcObject = s;
        remoteVideoRef.current.play().catch(() => {});
        setHasRemote(true);
      }
      if (remoteAudioRef.current) {
        remoteAudioRef.current.srcObject = s;
        remoteAudioRef.current.play().catch(() => {});
      }
    };

    pc.onconnectionstatechange = () => {
      console.log('ICE state:', pc.connectionState);
      if (pc.connectionState === 'connected') {
        setStatus('connected');
      }
      // Only hang up on 'failed', not on transient 'disconnected'
      if (pc.connectionState === 'failed') {
        hangUp();
      }
    };

    if (stream) {
      stream.getTracks().forEach((t) => pc.addTrack(t, stream!));
    }

    try {
      if (isCaller) {
        await setupCallerSignaling(pc, id);
      } else {
        await setupReceiverSignaling(pc, id);
      }
    } catch (err) {
      console.error('Signaling error:', err);
    }

    // Fallback: show connected after 6 s even if connectionstate event doesn't fire
    setTimeout(() => setStatus((s) => s === 'connecting' ? 'connected' : s), 6000);
  }

  // ── Cleanup ──────────────────────────────────────────────────────────────────
  /** leaveCall(deleteDoc) — set deleteDoc=false when other side already deleted it */
  async function leaveCall(deleteDoc = true) {
    if (hangingUpRef.current) return;
    hangingUpRef.current = true;

    localStreamRef.current?.getTracks().forEach((t) => t.stop());
    screenStreamRef.current?.getTracks().forEach((t) => t.stop());
    pcRef.current?.close();
    pcRef.current = null;

    if (deleteDoc && callId) {
      try {
        await cleanupCallData(callId);
        await endCall(callId);
      } catch { /* already deleted */ }
    }
    navigate(-1);
  }

  const hangUp = () => leaveCall(true);

  const stopSharing = async () => {
    const pc = pcRef.current;
    screenStreamRef.current?.getTracks().forEach((t) => t.stop());
    screenStreamRef.current = null;
    const camTrack = localStreamRef.current?.getVideoTracks()[0];
    if (pc && camTrack) {
      const sender = pc.getSenders().find((s) => s.track?.kind === 'video');
      await sender?.replaceTrack(camTrack);
      if (localVideoRef.current) localVideoRef.current.srcObject = localStreamRef.current;
    }
    setSharing(false);
  };

  const toggleShare = async () => {
    if (sharing) { stopSharing(); return; }

    if (!(navigator.mediaDevices as any).getDisplayMedia) {
      setShareError('Ваш браузер не поддерживает демонстрацию экрана');
      setTimeout(() => setShareError(''), 3000);
      return;
    }

    try {
      const screen: MediaStream = await (navigator.mediaDevices as any).getDisplayMedia({ video: true, audio: true });
      screenStreamRef.current = screen;
      const screenTrack = screen.getVideoTracks()[0];
      const pc = pcRef.current;
      if (pc) {
        const sender = pc.getSenders().find((s) => s.track?.kind === 'video');
        if (sender) {
          await sender.replaceTrack(screenTrack);
        } else {
          pc.addTrack(screenTrack, screen);
        }
      }
      if (localVideoRef.current) localVideoRef.current.srcObject = screen;
      screenTrack.onended = () => stopSharing();
      setSharing(true);
    } catch (err: any) {
      if (err?.name !== 'NotAllowedError') {
        setShareError('Не удалось начать демонстрацию экрана');
        setTimeout(() => setShareError(''), 3000);
      }
    }
  };

  const toggleMute = () => {
    localStreamRef.current?.getAudioTracks().forEach((t) => { t.enabled = muted; });
    setMuted((v) => !v);
  };

  const toggleVideo = () => {
    localStreamRef.current?.getVideoTracks().forEach((t) => { t.enabled = videoOff; });
    setVideoOff((v) => !v);
  };

  const toggleSpeaker = async () => {
    const el = remoteAudioRef.current as HTMLAudioElement & { setSinkId?: (id: string) => Promise<void> };
    if (el?.setSinkId) {
      try {
        const devices = await navigator.mediaDevices.enumerateDevices();
        const outputs = devices.filter((d) => d.kind === 'audiooutput');
        const target = speakerOn
          ? outputs.find((d) => d.label.toLowerCase().includes('earpiece') || d.deviceId !== 'default')
          : outputs.find((d) => d.deviceId === 'default');
        if (target) await el.setSinkId(target.deviceId);
      } catch { /* not supported */ }
    }
    setSpeakerOn((v) => !v);
  };

  // ── Render ───────────────────────────────────────────────────────────────────
  return (
    <div className="fixed inset-0 bg-gray-900 flex flex-col select-none">
      {/* Hidden audio for remote stream */}
      <audio ref={remoteAudioRef} autoPlay playsInline className="hidden" />

      {/* Remote video (full screen) */}
      <video
        ref={remoteVideoRef}
        autoPlay playsInline
        className={`absolute inset-0 w-full h-full object-cover transition-opacity duration-500 ${
          hasRemote && status === 'connected' ? 'opacity-100' : 'opacity-0'
        }`}
      />

      {/* Local video (PiP) */}
      {type === 'video' && (
        <video
          ref={localVideoRef}
          autoPlay playsInline muted
          className={`absolute top-16 right-4 w-28 h-40 object-cover rounded-2xl border-2 border-white/30 shadow-xl z-20 transition-opacity ${
            status === 'connected' ? 'opacity-100' : 'opacity-0'
          }`}
        />
      )}
      {type === 'audio' && <video ref={localVideoRef} autoPlay playsInline muted className="hidden" />}

      {/* Waiting / connecting overlay */}
      {(status === 'calling' || status === 'connecting') && (
        <div className="absolute inset-0 flex flex-col items-center justify-center bg-gray-900 z-10">
          <div className="w-28 h-28 rounded-full bg-gradient-to-br from-[#4F46E5] to-[#06B6D4] flex items-center justify-center mb-6 text-5xl font-bold text-white shadow-xl">
            {displayName.charAt(0).toUpperCase()}
          </div>
          <p className="text-white text-2xl font-medium mb-1">{displayName}</p>
          <p className="text-gray-400 text-sm animate-pulse">
            {status === 'calling' ? (type === 'video' ? 'Видеозвонок...' : 'Звонок...') : 'Подключение...'}
          </p>
          {status === 'connecting' && (
            <div className="mt-3 flex gap-2">
              {[0, 150, 300].map((d) => (
                <span key={d} className="w-2 h-2 rounded-full bg-[#4F46E5] animate-bounce" style={{ animationDelay: `${d}ms` }} />
              ))}
            </div>
          )}
          <button
            onClick={hangUp}
            className="mt-12 w-16 h-16 rounded-full bg-red-500 hover:bg-red-600 flex items-center justify-center shadow-lg"
          >
            <PhoneOff className="w-7 h-7 text-white" />
          </button>
          <span className="text-xs text-white/40 mt-2">Завершить</span>
        </div>
      )}

      {/* Audio-only avatar when connected */}
      {status === 'connected' && type === 'audio' && !hasRemote && (
        <div className="absolute inset-0 flex flex-col items-center justify-center bg-gray-800 z-0">
          <div className="w-28 h-28 rounded-full bg-gradient-to-br from-[#4F46E5] to-[#06B6D4] flex items-center justify-center text-5xl font-bold text-white shadow-xl mb-4">
            {displayName.charAt(0).toUpperCase()}
          </div>
          <p className="text-white text-xl font-medium">{displayName}</p>
          <p className="text-gray-400 text-sm mt-1">Звонок активен</p>
        </div>
      )}

      {status === 'declined' && (
        <div className="absolute inset-0 flex flex-col items-center justify-center bg-gray-900 z-10">
          <p className="text-white text-xl mb-1">{displayName}</p>
          <p className="text-red-400 text-sm">Звонок отклонён</p>
        </div>
      )}

      {/* Error toast */}
      {shareError && (
        <div className="absolute top-8 left-1/2 -translate-x-1/2 bg-gray-800 text-white text-sm px-4 py-2 rounded-xl z-50 shadow-lg">
          {shareError}
        </div>
      )}

      {/* Controls — only when connected */}
      {status === 'connected' && (
        <div className="absolute bottom-0 left-0 right-0 pb-10 pt-6 bg-gradient-to-t from-black/70 to-transparent z-30">
          <div className="flex items-center justify-center gap-4">
            <div className="flex flex-col items-center gap-1">
              <button
                onClick={toggleMute}
                className={`w-14 h-14 rounded-full flex items-center justify-center transition-all shadow-md ${
                  muted ? 'bg-red-500' : 'bg-white/20 hover:bg-white/30'
                }`}
              >
                {muted ? <MicOff className="w-6 h-6 text-white" /> : <Mic className="w-6 h-6 text-white" />}
              </button>
              <span className="text-xs text-white/50">{muted ? 'Выкл' : 'Микрофон'}</span>
            </div>

            <div className="flex flex-col items-center gap-1">
              <button
                onClick={hangUp}
                className="w-16 h-16 rounded-full bg-red-500 hover:bg-red-600 flex items-center justify-center shadow-lg"
              >
                <PhoneOff className="w-7 h-7 text-white" />
              </button>
              <span className="text-xs text-white/50">Завершить</span>
            </div>

            {type === 'video' ? (
              <div className="flex flex-col items-center gap-1">
                <button
                  onClick={toggleVideo}
                  className={`w-14 h-14 rounded-full flex items-center justify-center transition-all shadow-md ${
                    videoOff ? 'bg-red-500' : 'bg-white/20 hover:bg-white/30'
                  }`}
                >
                  {videoOff ? <VideoOff className="w-6 h-6 text-white" /> : <Video className="w-6 h-6 text-white" />}
                </button>
                <span className="text-xs text-white/50">{videoOff ? 'Камера выкл' : 'Камера'}</span>
              </div>
            ) : (
              <div className="flex flex-col items-center gap-1">
                <button
                  onClick={toggleSpeaker}
                  className={`w-14 h-14 rounded-full flex items-center justify-center transition-all shadow-md ${
                    speakerOn ? 'bg-white/20 hover:bg-white/30' : 'bg-red-500'
                  }`}
                >
                  {speakerOn ? <Volume2 className="w-6 h-6 text-white" /> : <VolumeX className="w-6 h-6 text-white" />}
                </button>
                <span className="text-xs text-white/50">{speakerOn ? 'Динамик' : 'Выкл'}</span>
              </div>
            )}

            <div className="flex flex-col items-center gap-1">
              <button
                onClick={toggleShare}
                className={`w-14 h-14 rounded-full flex items-center justify-center transition-all shadow-md ${
                  sharing ? 'bg-[#4F46E5]' : 'bg-white/20 hover:bg-white/30'
                }`}
              >
                {sharing ? <MonitorOff className="w-6 h-6 text-white" /> : <MonitorUp className="w-6 h-6 text-white" />}
              </button>
              <span className="text-xs text-white/50">{sharing ? 'Стоп' : 'Экран'}</span>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
