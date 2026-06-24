import { useEffect, useRef, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router';
import { PhoneOff, Mic, MicOff, Video, VideoOff, Volume2 } from 'lucide-react';

declare global {
  interface Window {
    JitsiMeetExternalAPI: new (domain: string, options: object) => JitsiAPI;
  }
}

interface JitsiAPI {
  dispose: () => void;
  executeCommand: (cmd: string, ...args: unknown[]) => void;
  addEventListeners: (listeners: Record<string, () => void>) => void;
}

export default function Call() {
  const navigate = useNavigate();
  const [params] = useSearchParams();
  const isVideo = params.get('type') !== 'audio';
  const userName = params.get('user') || 'User';
  const roomName = params.get('room') || `skillswap-${Math.random().toString(36).slice(2, 8)}`;

  const containerRef = useRef<HTMLDivElement>(null);
  const apiRef = useRef<JitsiAPI | null>(null);
  const [muted, setMuted] = useState(false);
  const [videoOff, setVideoOff] = useState(!isVideo);
  const [status, setStatus] = useState<'connecting' | 'connected' | 'ended'>('connecting');

  useEffect(() => {
    const script = document.createElement('script');
    script.src = 'https://meet.jit.si/external_api.js';
    script.async = true;
    script.onload = () => initJitsi();
    document.head.appendChild(script);
    return () => {
      apiRef.current?.dispose();
      document.head.removeChild(script);
    };
  }, []);

  function initJitsi() {
    if (!containerRef.current || !window.JitsiMeetExternalAPI) return;

    const api = new window.JitsiMeetExternalAPI('meet.jit.si', {
      roomName,
      width: '100%',
      height: '100%',
      parentNode: containerRef.current,
      userInfo: { displayName: 'Me' },
      configOverwrite: {
        startWithAudioMuted: false,
        startWithVideoMuted: !isVideo,
        prejoinPageEnabled: false,
        disableDeepLinking: true,
        toolbarButtons: [],
      },
      interfaceConfigOverwrite: {
        SHOW_JITSI_WATERMARK: false,
        SHOW_WATERMARK_FOR_GUESTS: false,
        TOOLBAR_BUTTONS: [],
        DISABLE_JOIN_LEAVE_NOTIFICATIONS: true,
        MOBILE_APP_PROMO: false,
      },
    });

    api.addEventListeners({
      videoConferenceJoined: () => setStatus('connected'),
      videoConferenceLeft: () => { setStatus('ended'); navigate(-1); },
    });

    apiRef.current = api;
  }

  const toggleMute = () => {
    apiRef.current?.executeCommand('toggleAudio');
    setMuted((v) => !v);
  };

  const toggleVideo = () => {
    apiRef.current?.executeCommand('toggleVideo');
    setVideoOff((v) => !v);
  };

  const hangUp = () => {
    apiRef.current?.executeCommand('hangup');
    navigate(-1);
  };

  return (
    <div className="fixed inset-0 bg-gray-900 flex flex-col">
      {/* Jitsi iframe container */}
      <div ref={containerRef} className="flex-1 w-full" />

      {/* Status overlay while connecting */}
      {status === 'connecting' && (
        <div className="absolute inset-0 flex flex-col items-center justify-center bg-gray-900 z-10">
          <div className="w-24 h-24 rounded-full bg-gray-700 flex items-center justify-center mb-6 text-4xl">
            👤
          </div>
          <p className="text-white text-xl mb-2">{userName}</p>
          <p className="text-gray-400 text-sm animate-pulse">
            {isVideo ? 'Видеозвонок...' : 'Звонок...'}
          </p>
        </div>
      )}

      {/* Controls */}
      <div className="absolute bottom-0 left-0 right-0 pb-10 pt-4 bg-gradient-to-t from-black/80 to-transparent z-20">
        <div className="flex items-center justify-center gap-6">
          {/* Mute */}
          <button
            onClick={toggleMute}
            className={`w-14 h-14 rounded-full flex items-center justify-center transition-all ${
              muted ? 'bg-red-500' : 'bg-white/20 hover:bg-white/30'
            }`}
          >
            {muted ? <MicOff className="w-6 h-6 text-white" /> : <Mic className="w-6 h-6 text-white" />}
          </button>

          {/* Hang up */}
          <button
            onClick={hangUp}
            className="w-16 h-16 rounded-full bg-red-500 hover:bg-red-600 flex items-center justify-center transition-all shadow-lg"
          >
            <PhoneOff className="w-7 h-7 text-white" />
          </button>

          {/* Video toggle */}
          {isVideo ? (
            <button
              onClick={toggleVideo}
              className={`w-14 h-14 rounded-full flex items-center justify-center transition-all ${
                videoOff ? 'bg-red-500' : 'bg-white/20 hover:bg-white/30'
              }`}
            >
              {videoOff ? <VideoOff className="w-6 h-6 text-white" /> : <Video className="w-6 h-6 text-white" />}
            </button>
          ) : (
            <button className="w-14 h-14 rounded-full bg-white/20 hover:bg-white/30 flex items-center justify-center">
              <Volume2 className="w-6 h-6 text-white" />
            </button>
          )}
        </div>
      </div>
    </div>
  );
}
