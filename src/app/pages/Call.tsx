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

declare global {
  interface Window {
    JitsiMeetExternalAPI: new (domain: string, options: object) => JitsiAPI;
  }
}
interface JitsiAPI {
  dispose: () => void;
  executeCommand: (cmd: string, ...args: unknown[]) => void;
  addEventListeners: (l: Record<string, () => void>) => void;
  isAudioMuted: () => Promise<boolean>;
}

export default function Call() {
  const navigate = useNavigate();
  const [params] = useSearchParams();
  const { user: currentUser } = useAuth();

  const receiverId = params.get('userId') || '';
  const receiverName = params.get('userName') || 'User';
  const type = (params.get('type') || 'video') as 'audio' | 'video';
  const incomingCallId = params.get('callId') || '';

  const containerRef = useRef<HTMLDivElement>(null);
  const apiRef = useRef<JitsiAPI | null>(null);
  const jitsiStarted = useRef(false);

  const [callId, setCallId] = useState('');
  const [status, setStatus] = useState<'calling' | 'connecting' | 'connected' | 'declined'>('calling');
  const [callData, setCallData] = useState<CallDoc | null>(null);
  const [muted, setMuted] = useState(false);
  const [videoOff, setVideoOff] = useState(type === 'audio');
  const [speakerOn, setSpeakerOn] = useState(true);

  const isCaller = !incomingCallId;

  // Step 1: Init call in Firestore
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

  // Step 2: Listen for call state changes
  useEffect(() => {
    if (!callId || !currentUser) return;

    const unsub = listenCall(callId, (data) => {
      if (!data) {
        apiRef.current?.dispose();
        navigate(-1);
        return;
      }
      setCallData(data);

      // Caller: start when receiver accepted
      if (isCaller && data.status === 'accepted' && !jitsiStarted.current) {
        jitsiStarted.current = true;
        setStatus('connecting');
        startJitsi(data.roomName);
      }

      if (isCaller && data.status === 'declined') {
        setStatus('declined');
        setTimeout(() => navigate(-1), 2000);
      }

      // Receiver: start immediately (they already accepted)
      if (!isCaller && !jitsiStarted.current && (data.status === 'accepted' || data.status === 'calling')) {
        jitsiStarted.current = true;
        setStatus('connecting');
        startJitsi(data.roomName);
      }
    });

    return unsub;
  }, [callId, currentUser]);

  // Auto-timeout 30s for unanswered call
  useEffect(() => {
    if (!isCaller || !callId) return;
    const t = setTimeout(() => {
      endCall(callId).then(() => navigate(-1));
    }, 30000);
    return () => clearTimeout(t);
  }, [callId]);

  function startJitsi(room: string) {
    if (document.querySelector('script[src*="meet.jit.si/external_api"]')) {
      // Script already loaded
      initJitsi(room);
      return;
    }
    const script = document.createElement('script');
    script.src = 'https://meet.jit.si/external_api.js';
    script.async = true;
    script.onload = () => initJitsi(room);
    document.head.appendChild(script);
  }

  function initJitsi(room: string) {
    if (!containerRef.current || apiRef.current) return;

    const api = new window.JitsiMeetExternalAPI('meet.jit.si', {
      roomName: room,
      width: '100%',
      height: '100%',
      parentNode: containerRef.current,
      userInfo: { displayName: currentUser?.displayName || currentUser?.email || 'User' },
      configOverwrite: {
        startWithAudioMuted: false,
        startWithVideoMuted: type === 'audio',
        prejoinPageEnabled: false,
        disableDeepLinking: true,
        toolbarButtons: [],
        disableInviteFunctions: true,
      },
      interfaceConfigOverwrite: {
        SHOW_JITSI_WATERMARK: false,
        TOOLBAR_BUTTONS: [],
        DISABLE_JOIN_LEAVE_NOTIFICATIONS: true,
        MOBILE_APP_PROMO: false,
      },
    });

    api.addEventListeners({
      videoConferenceJoined: () => setStatus('connected'),
      videoConferenceLeft: () => hangUp(),
    });

    apiRef.current = api;

    // Fallback: hide overlay after 5s regardless of event
    setTimeout(() => setStatus((s) => s === 'connecting' ? 'connected' : s), 5000);
  }

  const hangUp = async () => {
    apiRef.current?.dispose();
    apiRef.current = null;
    if (callId) await endCall(callId);
    navigate(-1);
  };

  const toggleMute = () => {
    apiRef.current?.executeCommand('toggleAudio');
    setMuted((v) => !v);
  };

  const toggleVideo = () => {
    apiRef.current?.executeCommand('toggleVideo');
    setVideoOff((v) => !v);
  };

  const toggleSpeaker = async () => {
    // Try to switch audio output device using Web Audio API
    try {
      const devices = await navigator.mediaDevices.enumerateDevices();
      const audioOutputs = devices.filter((d) => d.kind === 'audiooutput');
      // Toggle between devices if multiple exist
      if (audioOutputs.length > 1) {
        const iframe = containerRef.current?.querySelector('iframe');
        const videos = iframe?.contentDocument?.querySelectorAll('video, audio');
        if (videos) {
          const targetDevice = speakerOn
            ? audioOutputs.find((d) => d.label.toLowerCase().includes('earpiece') || d.deviceId !== 'default')
            : audioOutputs.find((d) => d.deviceId === 'default');
          if (targetDevice) {
            videos.forEach((el) => {
              const mediaEl = el as HTMLMediaElement & { setSinkId?: (id: string) => Promise<void> };
              mediaEl.setSinkId?.(targetDevice.deviceId);
            });
          }
        }
      }
    } catch {
      // setSinkId not supported — just toggle visual state
    }
    setSpeakerOn((v) => !v);
  };

  const displayName = isCaller ? receiverName : (callData?.callerName || 'User');

  return (
    <div className="fixed inset-0 bg-gray-900 flex flex-col">
      {/* Waiting / calling overlay — covers everything until Jitsi is ready */}
      {(status === 'calling' || status === 'connecting') && (
        <div className="absolute inset-0 flex flex-col items-center justify-center bg-gray-900 z-30">
          <div className="w-24 h-24 rounded-full bg-gradient-to-br from-[#4F46E5] to-[#06B6D4] flex items-center justify-center mb-6 text-4xl font-bold text-white">
            {displayName.charAt(0).toUpperCase()}
          </div>
          <p className="text-white text-xl mb-2">{displayName}</p>
          <p className="text-gray-400 text-sm animate-pulse">
            {status === 'calling'
              ? (type === 'video' ? 'Видеозвонок...' : 'Звонок...')
              : 'Подключение...'}
          </p>
          {status === 'connecting' && (
            <div className="mt-4 flex gap-1">
              <span className="w-2 h-2 rounded-full bg-[#4F46E5] animate-bounce" style={{ animationDelay: '0ms' }} />
              <span className="w-2 h-2 rounded-full bg-[#4F46E5] animate-bounce" style={{ animationDelay: '150ms' }} />
              <span className="w-2 h-2 rounded-full bg-[#4F46E5] animate-bounce" style={{ animationDelay: '300ms' }} />
            </div>
          )}
          {/* Hang up while waiting */}
          <button
            onClick={hangUp}
            className="mt-10 w-16 h-16 rounded-full bg-red-500 hover:bg-red-600 flex items-center justify-center transition-all shadow-lg"
          >
            <PhoneOff className="w-7 h-7 text-white" />
          </button>
        </div>
      )}

      {status === 'declined' && (
        <div className="absolute inset-0 flex flex-col items-center justify-center bg-gray-900 z-30">
          <p className="text-white text-xl mb-2">{displayName}</p>
          <p className="text-red-400 text-sm mt-1">Звонок отклонён</p>
        </div>
      )}

      {/* Jitsi fills the top portion; controls bar sits below */}
      <div
        ref={containerRef}
        className="w-full"
        style={{ height: status === 'connected' ? 'calc(100% - 90px)' : '0px', overflow: 'hidden' }}
      />

      {/* Controls — only shown when call is connected, below the Jitsi iframe */}
      {status === 'connected' && (
        <div className="h-[90px] bg-gray-900 flex flex-col items-center justify-center gap-1">
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

          <div className="flex items-center justify-center gap-6">
            <span className="w-14 text-center text-xs text-white/50">{muted ? 'Выкл' : 'Микрофон'}</span>
            <span className="w-16 text-center text-xs text-white/50">Завершить</span>
            <span className="w-14 text-center text-xs text-white/50">
              {type === 'video' ? (videoOff ? 'Камера выкл' : 'Камера') : (speakerOn ? 'Динамик' : 'Выкл')}
            </span>
          </div>
        </div>
      )}
    </div>
  );
}
