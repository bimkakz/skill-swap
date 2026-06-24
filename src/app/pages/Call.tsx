import { useEffect, useRef, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router';
import { PhoneOff, Mic, MicOff, Video, VideoOff, Volume2, VolumeX } from 'lucide-react';
import { useAuth } from '../../lib/AuthContext';
import {
  initiateCall,
  acceptCall,
  endCall,
  listenCall,
  CallDoc,
} from '../../lib/callSignaling';
import { createPC, setupCallerSignaling, setupReceiverSignaling, cleanupCallData } from '../../lib/webrtcCall';

export default function Call() {
  const navigate = useNavigate();
  const [params] = useSearchParams();
  const { user: currentUser } = useAuth();

  const receiverId = params.get('userId') || '';
  const receiverName = params.get('userName') || 'User';
  const type = (params.get('type') || 'video') as 'audio' | 'video';
  const incomingCallId = params.get('callId') || '';

  const localVideoRef = useRef<HTMLVideoElement>(null);
  const remoteVideoRef = useRef<HTMLVideoElement>(null);
  const remoteAudioRef = useRef<HTMLAudioElement>(null);
  const pcRef = useRef<RTCPeerConnection | null>(null);
  const localStreamRef = useRef<MediaStream | null>(null);
  const startedRef = useRef(false);

  const [callId, setCallId] = useState('');
  const [callData, setCallData] = useState<CallDoc | null>(null);
  const [status, setStatus] = useState<'calling' | 'connecting' | 'connected' | 'declined'>('calling');
  const [muted, setMuted] = useState(false);
  const [videoOff, setVideoOff] = useState(false);
  const [speakerOn, setSpeakerOn] = useState(true);
  const [hasRemoteVideo, setHasRemoteVideo] = useState(false);

  const isCaller = !incomingCallId;
  const displayName = isCaller ? receiverName : (callData?.callerName || 'User');

  // Step 1: Init signaling doc
  useEffect(() => {
    if (!currentUser) return;
    if (isCaller) {
      initiateCall(
        currentUser.uid,
        currentUser.displayName || currentUser.email || 'User',
        receiverId,
        receiverName,
        type
      ).then(({ id }) => setCallId(id));
    } else {
      setCallId(incomingCallId);
      acceptCall(incomingCallId);
    }
  }, [currentUser]);

  // Step 2: Listen for signaling state changes
  useEffect(() => {
    if (!callId || !currentUser) return;
    const unsub = listenCall(callId, (data) => {
      if (!data) { hangUp(); return; }
      setCallData(data);
      if (isCaller && data.status === 'declined') {
        setStatus('declined');
        setTimeout(() => navigate(-1), 2000);
        return;
      }
      // Start WebRTC once receiver has accepted
      if (!startedRef.current && (
        (isCaller && data.status === 'accepted') ||
        (!isCaller && (data.status === 'accepted' || data.status === 'calling'))
      )) {
        startedRef.current = true;
        startWebRTC(callId);
      }
    });
    return unsub;
  }, [callId, currentUser]);

  // 30s timeout for unanswered outgoing calls — cancelled once WebRTC starts
  const noAnswerTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  useEffect(() => {
    if (!isCaller || !callId) return;
    noAnswerTimerRef.current = setTimeout(() => {
      if (!startedRef.current) {
        endCall(callId).then(() => navigate(-1));
      }
    }, 30000);
    return () => {
      if (noAnswerTimerRef.current) clearTimeout(noAnswerTimerRef.current);
    };
  }, [callId]);

  async function startWebRTC(id: string) {
    setStatus('connecting');
    try {
      // Try with ideal constraints first, fall back to basic if browser rejects
      let stream: MediaStream;
      try {
        stream = await navigator.mediaDevices.getUserMedia({
          audio: true,
          video: type === 'video' ? { facingMode: { ideal: 'user' } } : false,
        });
      } catch {
        // Fallback: just ask for audio/video without extra constraints
        stream = await navigator.mediaDevices.getUserMedia({
          audio: true,
          video: type === 'video',
        });
      }
      localStreamRef.current = stream;
      if (localVideoRef.current) {
        localVideoRef.current.srcObject = stream;
      }

      const pc = createPC();
      pcRef.current = pc;

      // ontrack MUST be set before signaling so we don't miss early track events
      pc.ontrack = (e) => {
        const remoteStream = e.streams[0];
        if (remoteVideoRef.current) {
          remoteVideoRef.current.srcObject = remoteStream;
          remoteVideoRef.current.play().catch(() => {});
          setHasRemoteVideo(true);
        }
        if (remoteAudioRef.current) {
          remoteAudioRef.current.srcObject = remoteStream;
          remoteAudioRef.current.play().catch(() => {});
        }
      };

      // Tracks MUST be added before creating offer/answer
      stream.getTracks().forEach((t) => pc.addTrack(t, stream));

      if (isCaller) {
        await setupCallerSignaling(pc, id);
      } else {
        await setupReceiverSignaling(pc, id);
      }

      pc.onconnectionstatechange = () => {
        if (pc.connectionState === 'connected') setStatus('connected');
        if (pc.connectionState === 'disconnected' || pc.connectionState === 'failed') hangUp();
      };

      // Fallback: show connected after 8s
      setTimeout(() => setStatus((s) => s === 'connecting' ? 'connected' : s), 8000);
    } catch (err) {
      console.error('WebRTC error:', err);
      hangUp();
    }
  }

  const hangUp = async () => {
    localStreamRef.current?.getTracks().forEach((t) => t.stop());
    pcRef.current?.close();
    pcRef.current = null;
    if (callId) {
      await cleanupCallData(callId);
      await endCall(callId);
    }
    navigate(-1);
  };

  const toggleMute = () => {
    localStreamRef.current?.getAudioTracks().forEach((t) => { t.enabled = !t.enabled; });
    setMuted((v) => !v);
  };

  const toggleVideo = () => {
    localStreamRef.current?.getVideoTracks().forEach((t) => { t.enabled = !t.enabled; });
    setVideoOff((v) => !v);
  };

  const toggleSpeaker = async () => {
    const video = remoteVideoRef.current as HTMLVideoElement & { setSinkId?: (id: string) => Promise<void> };
    if (video?.setSinkId) {
      try {
        const devices = await navigator.mediaDevices.enumerateDevices();
        const outputs = devices.filter((d) => d.kind === 'audiooutput');
        const target = speakerOn
          ? outputs.find((d) => d.label.toLowerCase().includes('earpiece') || d.deviceId !== 'default')
          : outputs.find((d) => d.deviceId === 'default');
        if (target) await video.setSinkId(target.deviceId);
      } catch { /* not supported */ }
    }
    setSpeakerOn((v) => !v);
  };

  return (
    <div className="fixed inset-0 bg-gray-900 flex flex-col">
      {/* Hidden audio element — ensures remote audio plays even on audio-only calls */}
      <audio ref={remoteAudioRef} autoPlay playsInline className="hidden" />

      {/* Remote video (full screen) */}
      <video
        ref={remoteVideoRef}
        autoPlay
        playsInline
        className={`absolute inset-0 w-full h-full object-cover transition-opacity duration-300 ${
          hasRemoteVideo && status === 'connected' ? 'opacity-100' : 'opacity-0'
        }`}
      />

      {/* Local video (picture-in-picture, top-right) */}
      {type === 'video' && (
        <video
          ref={localVideoRef}
          autoPlay
          playsInline
          muted
          className={`absolute top-16 right-4 w-28 h-40 object-cover rounded-2xl border-2 border-white/30 shadow-xl z-20 transition-opacity ${
            status === 'connected' ? 'opacity-100' : 'opacity-0'
          }`}
        />
      )}

      {/* Audio-only: hidden local video still needed for stream */}
      {type === 'audio' && (
        <video ref={localVideoRef} autoPlay playsInline muted className="hidden" />
      )}

      {/* Waiting / connecting overlay */}
      {(status === 'calling' || status === 'connecting') && (
        <div className="absolute inset-0 flex flex-col items-center justify-center bg-gray-900 z-10">
          <div className="w-28 h-28 rounded-full bg-gradient-to-br from-[#4F46E5] to-[#06B6D4] flex items-center justify-center mb-6 text-5xl font-bold text-white shadow-xl">
            {displayName.charAt(0).toUpperCase()}
          </div>
          <p className="text-white text-2xl font-medium mb-2">{displayName}</p>
          <p className="text-gray-400 text-sm animate-pulse mt-1">
            {status === 'calling'
              ? (type === 'video' ? 'Видеозвонок...' : 'Звонок...')
              : 'Подключение...'}
          </p>
          {status === 'connecting' && (
            <div className="mt-4 flex gap-2">
              <span className="w-2 h-2 rounded-full bg-[#4F46E5] animate-bounce" style={{ animationDelay: '0ms' }} />
              <span className="w-2 h-2 rounded-full bg-[#4F46E5] animate-bounce" style={{ animationDelay: '150ms' }} />
              <span className="w-2 h-2 rounded-full bg-[#4F46E5] animate-bounce" style={{ animationDelay: '300ms' }} />
            </div>
          )}

          {/* Hang up while waiting */}
          <button
            onClick={hangUp}
            className="mt-12 w-16 h-16 rounded-full bg-red-500 hover:bg-red-600 flex items-center justify-center transition-all shadow-lg"
          >
            <PhoneOff className="w-7 h-7 text-white" />
          </button>
          <span className="text-xs text-white/40 mt-2">Завершить</span>
        </div>
      )}

      {/* Audio-only avatar when connected */}
      {status === 'connected' && type === 'audio' && (
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
          <p className="text-white text-xl mb-2">{displayName}</p>
          <p className="text-red-400 text-sm mt-1">Звонок отклонён</p>
        </div>
      )}

      {/* Controls bar — always shown (above or over content) */}
      <div className="absolute bottom-0 left-0 right-0 pb-10 pt-6 bg-gradient-to-t from-black/70 to-transparent z-30">
        <div className="flex items-center justify-center gap-6">
          <button
            onClick={toggleMute}
            className={`w-14 h-14 rounded-full flex items-center justify-center transition-all shadow-md ${
              muted ? 'bg-red-500 hover:bg-red-600' : 'bg-white/20 hover:bg-white/30'
            }`}
          >
            {muted ? <MicOff className="w-6 h-6 text-white" /> : <Mic className="w-6 h-6 text-white" />}
          </button>

          <button
            onClick={hangUp}
            className="w-16 h-16 rounded-full bg-red-500 hover:bg-red-600 flex items-center justify-center transition-all shadow-lg"
          >
            <PhoneOff className="w-7 h-7 text-white" />
          </button>

          {type === 'video' ? (
            <button
              onClick={toggleVideo}
              className={`w-14 h-14 rounded-full flex items-center justify-center transition-all shadow-md ${
                videoOff ? 'bg-red-500 hover:bg-red-600' : 'bg-white/20 hover:bg-white/30'
              }`}
            >
              {videoOff ? <VideoOff className="w-6 h-6 text-white" /> : <Video className="w-6 h-6 text-white" />}
            </button>
          ) : (
            <button
              onClick={toggleSpeaker}
              className={`w-14 h-14 rounded-full flex items-center justify-center transition-all shadow-md ${
                speakerOn ? 'bg-white/20 hover:bg-white/30' : 'bg-red-500 hover:bg-red-600'
              }`}
            >
              {speakerOn ? <Volume2 className="w-6 h-6 text-white" /> : <VolumeX className="w-6 h-6 text-white" />}
            </button>
          )}
        </div>

        <div className="flex items-center justify-center gap-6 mt-2">
          <span className="w-14 text-center text-xs text-white/50">{muted ? 'Выкл' : 'Микрофон'}</span>
          <span className="w-16 text-center text-xs text-white/50">Завершить</span>
          <span className="w-14 text-center text-xs text-white/50">
            {type === 'video' ? (videoOff ? 'Камера выкл' : 'Камера') : (speakerOn ? 'Динамик' : 'Выкл')}
          </span>
        </div>
      </div>
    </div>
  );
}
