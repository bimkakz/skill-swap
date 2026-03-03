import { Wifi, Battery, Signal } from 'lucide-react';

interface StatusBarProps {
  theme?: 'light' | 'dark';
}

export function StatusBar({ theme = 'dark' }: StatusBarProps) {
  const textColor = theme === 'dark' ? 'text-white' : 'text-gray-900';
  
  // Get current time
  const now = new Date();
  const hours = now.getHours().toString().padStart(2, '0');
  const minutes = now.getMinutes().toString().padStart(2, '0');
  const time = `${hours}:${minutes}`;

  return (
    <div className={`flex items-center justify-between px-6 pt-3 pb-2 ${textColor}`}>
      {/* Left side - Time */}
      <div className="flex items-center gap-1">
        <span className="text-sm font-semibold">{time}</span>
      </div>

      {/* Right side - Icons */}
      <div className="flex items-center gap-1.5">
        <Signal className="w-4 h-4" />
        <Wifi className="w-4 h-4" />
        <div className="flex items-center gap-0.5">
          <Battery className="w-5 h-4" />
        </div>
      </div>
    </div>
  );
}
