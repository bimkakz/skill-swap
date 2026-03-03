import { Search, MessageCircle } from 'lucide-react';
import { useNavigate } from 'react-router';
import { BottomNav } from '../components/BottomNav';
import { ImageWithFallback } from '../components/figma/ImageWithFallback';

const conversations = [
  {
    id: 1,
    user: {
      name: 'Maria Garcia',
      image: 'https://images.unsplash.com/photo-1770564512654-35be546ed257?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx5b3VuZyUyMHdvbWFuJTIwc21pbGluZyUyMGNhc3VhbHxlbnwxfHx8fDE3NzEzODg1MDJ8MA&ixlib=rb-4.1.0&q=80&w=1080',
    },
    lastMessage: "Great! Let's start next week then.",
    time: '2m ago',
    unread: 2,
    online: true,
  },
  {
    id: 2,
    user: {
      name: 'David Kim',
      image: 'https://images.unsplash.com/photo-1764816657425-b3c79b616d14?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtYW4lMjBjYXN1YWwlMjBwb3J0cmFpdCUyMGZyaWVuZGx5fGVufDF8fHx8MTc3MTM2MzM4M3ww&ixlib=rb-4.1.0&q=80&w=1080',
    },
    lastMessage: 'Thanks for the piano lesson!',
    time: '1h ago',
    unread: 0,
    online: false,
  },
  {
    id: 3,
    user: {
      name: 'Sophie Laurent',
      image: 'https://images.unsplash.com/photo-1623594675959-02360202d4d6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx3b21hbiUyMHNtaWxpbmclMjBwb3J0cmFpdCUyMHByb2Zlc3Npb25hbHxlbnwxfHx8fDE3NzEzMjkyOTJ8MA&ixlib=rb-4.1.0&q=80&w=1080',
    },
    lastMessage: 'Can we reschedule to tomorrow?',
    time: '3h ago',
    unread: 1,
    online: true,
  },
  {
    id: 4,
    user: {
      name: 'Alex Morgan',
      image: 'https://images.unsplash.com/photo-1680721698104-5fff20073eee?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtYW4lMjBwb3J0cmFpdCUyMGZyaWVuZGx5JTIweW91bmd8ZW58MXx8fHwxNzcxMzg4NDU1fDA&ixlib=rb-4.1.0&q=80&w=1080',
    },
    lastMessage: 'The guitar lesson was amazing!',
    time: '2d ago',
    unread: 0,
    online: false,
  },
];

export default function Messages() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      <div className="max-w-md mx-auto">
        {/* Header */}
        <div className="bg-white px-6 pt-12 pb-6 rounded-b-3xl shadow-sm">
          <h1 className="text-2xl text-gray-900 mb-6">Messages</h1>

          {/* Search Bar */}
          <div className="relative">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              placeholder="Search conversations..."
              className="w-full pl-12 pr-4 py-3 bg-gray-100 rounded-2xl focus:outline-none focus:ring-2 focus:ring-[#4F46E5]/20"
            />
          </div>
        </div>

        {/* Conversations List */}
        <div className="px-6 mt-6 space-y-3">
          {conversations.map((conversation) => (
            <div
              key={conversation.id}
              onClick={() => navigate('/chat')}
              className="bg-white rounded-2xl p-4 shadow-sm hover:shadow-md transition-all cursor-pointer"
            >
              <div className="flex items-center gap-4">
                <div className="relative flex-shrink-0">
                  <div className="w-14 h-14 rounded-full overflow-hidden bg-gray-200">
                    <ImageWithFallback
                      src={conversation.user.image}
                      alt={conversation.user.name}
                      className="w-full h-full object-cover"
                    />
                  </div>
                  {conversation.online && (
                    <div className="absolute bottom-0 right-0 w-4 h-4 bg-green-500 rounded-full border-2 border-white"></div>
                  )}
                </div>

                <div className="flex-1 min-w-0">
                  <div className="flex items-center justify-between mb-1">
                    <h3 className="text-gray-900 truncate">{conversation.user.name}</h3>
                    <span className="text-xs text-gray-500 flex-shrink-0 ml-2">
                      {conversation.time}
                    </span>
                  </div>
                  <div className="flex items-center justify-between">
                    <p className="text-sm text-gray-600 truncate flex-1">
                      {conversation.lastMessage}
                    </p>
                    {conversation.unread > 0 && (
                      <div className="w-5 h-5 rounded-full bg-[#4F46E5] flex items-center justify-center flex-shrink-0 ml-2">
                        <span className="text-xs text-white">{conversation.unread}</span>
                      </div>
                    )}
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Empty State (if no messages) */}
        {conversations.length === 0 && (
          <div className="flex flex-col items-center justify-center py-20 px-6">
            <div className="w-20 h-20 rounded-full bg-gray-100 flex items-center justify-center mb-4">
              <MessageCircle className="w-10 h-10 text-gray-400" />
            </div>
            <h3 className="text-gray-900 mb-2">No messages yet</h3>
            <p className="text-gray-600 text-sm text-center mb-6">
              Start connecting with teachers and learners to begin your journey!
            </p>
            <button
              onClick={() => navigate('/home')}
              className="px-6 py-3 bg-[#4F46E5] text-white rounded-2xl hover:bg-[#4338CA] transition-colors"
            >
              Explore SkillSwap
            </button>
          </div>
        )}
      </div>

      <BottomNav />
    </div>
  );
}
