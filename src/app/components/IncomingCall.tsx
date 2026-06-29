import { Phone, PhoneOff, Video } from 'lucide-react';

interface Props {
  callerName: string;
  type: 'audio' | 'video';
  onAccept: () => void;
  onDecline: () => void;
}

export function IncomingCall({ callerName, type, onAccept, onDecline }: Props) {
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm">
      <div className="bg-gray-900 rounded-3xl p-8 w-72 flex flex-col items-center gap-6 shadow-2xl">
        <div className="w-20 h-20 rounded-full bg-gradient-to-br from-[#4F46E5] to-[#06B6D4] flex items-center justify-center text-3xl font-bold text-white">
          {callerName.charAt(0).toUpperCase()}
        </div>
        <div className="text-center">
          <p className="text-white text-xl font-semibold">{callerName}</p>
          <p className="text-gray-400 text-sm mt-1 animate-pulse">
            {type === 'video' ? 'Входящий видеозвонок...' : 'Входящий звонок...'}
          </p>
        </div>
        <div className="flex gap-8">
          <button
            onClick={onDecline}
            className="w-16 h-16 rounded-full bg-red-500 hover:bg-red-600 flex items-center justify-center transition-all shadow-lg"
          >
            <PhoneOff className="w-7 h-7 text-white" />
          </button>
          <button
            onClick={onAccept}
            className="w-16 h-16 rounded-full bg-green-500 hover:bg-green-600 flex items-center justify-center transition-all shadow-lg"
          >
            {type === 'video' ? <Video className="w-7 h-7 text-white" /> : <Phone className="w-7 h-7 text-white" />}
          </button>
        </div>
      </div>
    </div>
  );
}
