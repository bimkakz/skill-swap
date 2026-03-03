import { Coins } from 'lucide-react';

interface PointsBalanceProps {
  points: number;
  size?: 'small' | 'medium' | 'large';
  className?: string;
}

export function PointsBalance({ points, size = 'medium', className = '' }: PointsBalanceProps) {
  const sizes = {
    small: {
      container: 'px-3 py-1.5',
      icon: 'w-4 h-4',
      text: 'text-sm',
    },
    medium: {
      container: 'px-4 py-2',
      icon: 'w-5 h-5',
      text: 'text-base',
    },
    large: {
      container: 'px-5 py-3',
      icon: 'w-6 h-6',
      text: 'text-lg',
    },
  };

  const sizeClasses = sizes[size];

  return (
    <div
      className={`bg-gradient-to-r from-amber-400 to-orange-500 rounded-full ${sizeClasses.container} flex items-center gap-2 shadow-lg ${className}`}
    >
      <Coins className={`${sizeClasses.icon} text-white`} />
      <span className={`${sizeClasses.text} text-white font-semibold`}>
        {points.toLocaleString()}
      </span>
    </div>
  );
}
