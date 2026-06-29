import { Home, Search, MessageCircle, User } from 'lucide-react';
import { Link, useLocation } from 'react-router';

export function BottomNav() {
  const location = useLocation();

  const isActive = (path: string) => location.pathname === path;

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-xl border-t border-gray-200/80 shadow-lg z-40">
      <div className="max-w-md mx-auto flex justify-around items-center py-2 px-4">
        <Link
          to="/home"
          className={`flex flex-col items-center justify-center flex-1 transition-colors py-2 ${isActive('/home') ? 'text-[#4F46E5]' : 'text-gray-500'}`}
        >
          <Home className={`w-6 h-6 ${isActive('/home') ? 'fill-[#4F46E5]' : ''}`} />
          <span className="text-xs mt-1">Home</span>
        </Link>

        <Link
          to="/explore"
          className={`flex flex-col items-center justify-center flex-1 transition-colors py-2 ${isActive('/explore') ? 'text-[#4F46E5]' : 'text-gray-500'}`}
        >
          <Search className="w-6 h-6" />
          <span className="text-xs mt-1">Explore</span>
        </Link>

        <Link
          to="/messages"
          className={`flex flex-col items-center justify-center flex-1 transition-colors py-2 ${isActive('/messages') ? 'text-[#4F46E5]' : 'text-gray-500'}`}
        >
          <MessageCircle className={`w-6 h-6 ${isActive('/messages') ? 'fill-[#4F46E5]' : ''}`} />
          <span className="text-xs mt-1">Messages</span>
        </Link>

        <Link
          to="/profile"
          className={`flex flex-col items-center justify-center flex-1 transition-colors py-2 ${isActive('/profile') ? 'text-[#4F46E5]' : 'text-gray-500'}`}
        >
          <User className={`w-6 h-6 ${isActive('/profile') ? 'fill-[#4F46E5]' : ''}`} />
          <span className="text-xs mt-1">Profile</span>
        </Link>
      </div>
    </div>
  );
}
