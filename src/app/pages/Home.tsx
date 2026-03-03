import { Search, Repeat, GraduationCap, Sparkles, TrendingUp, Star } from 'lucide-react';
import { useNavigate } from 'react-router';
import { BottomNav } from '../components/BottomNav';
import { ImageWithFallback } from '../components/figma/ImageWithFallback';
import { PointsBalance } from '../components/PointsBalance';
import { StatusBar } from '../components/StatusBar';

const recommendations = [
  {
    id: 1,
    name: 'Sarah Chen',
    image: 'https://images.unsplash.com/photo-1581065178047-8ee15951ede6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxhc2lhbiUyMHdvbWFuJTIwcG9ydHJhaXQlMjBwcm9mZXNzaW9uYWx8ZW58MXx8fHwxNzcxMzM2NDMyfDA&ixlib=rb-4.1.0&q=80&w=1080',
    skill: 'Japanese Language',
    rating: 4.9,
    type: 'exchange',
    points: 50,
  },
  {
    id: 2,
    name: 'Alex Morgan',
    image: 'https://images.unsplash.com/photo-1680721698104-5fff20073eee?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtYW4lMjBwb3J0cmFpdCUyMGZyaWVuZGx5JTIweW91bmd8ZW58MXx8fHwxNzcxMzg4NDU1fDA&ixlib=rb-4.1.0&q=80&w=1080',
    skill: 'Guitar & Music',
    rating: 4.8,
    type: 'paid',
    price: '$25/hr',
  },
  {
    id: 3,
    name: 'Emma Wilson',
    image: 'https://images.unsplash.com/photo-1623594675959-02360202d4d6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx3b21hbiUyMHNtaWxpbmclMjBwb3J0cmFpdCUyMHByb2Zlc3Npb25hbHxlbnwxfHx8fDE3NzEzMjkyOTJ8MA&ixlib=rb-4.1.0&q=80&w=1080',
    skill: 'Digital Marketing',
    rating: 5.0,
    type: 'exchange',
    points: 75,
  },
];

export default function Home() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-md mx-auto">
        {/* Status Bar */}
        <div className="bg-white">
          <StatusBar theme="light" />
        </div>

        {/* Header */}
        <div className="bg-white px-6 pb-6 rounded-b-[32px] shadow-sm">
          <div className="flex items-center justify-between mb-6">
            <div>
              <h1 className="text-2xl text-gray-900">Hello, Alex 👋</h1>
              <p className="text-gray-600 text-sm mt-1">What would you like to learn today?</p>
            </div>
            <div className="flex flex-col items-end gap-2">
              <div className="w-12 h-12 rounded-full bg-gradient-to-br from-[#4F46E5] to-[#22C55E] flex items-center justify-center text-white text-lg shadow-lg">
                A
              </div>
              <PointsBalance points={1250} size="small" />
            </div>
          </div>

          {/* Search Bar */}
          <div className="relative">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              placeholder="Search skills or teachers..."
              className="w-full pl-12 pr-4 py-3 bg-gray-100 rounded-2xl focus:outline-none focus:ring-2 focus:ring-[#4F46E5]/20"
            />
          </div>
        </div>

        {/* Learning Modes */}
        <div className="px-6 mt-6">
          <h3 className="text-gray-900 mb-4">Choose Your Learning Path</h3>
          <div className="grid grid-cols-1 gap-3">
            {/* Exchange Skills Card */}
            <button
              onClick={() => navigate('/skill-exchange')}
              className="bg-gradient-to-br from-[#4F46E5] to-[#6366F1] rounded-2xl p-6 text-left shadow-lg hover:shadow-xl transition-all"
            >
              <div className="flex items-start justify-between">
                <div className="flex-1">
                  <div className="flex items-center gap-2 mb-2">
                    <Repeat className="w-6 h-6 text-white" />
                    <h4 className="text-white text-lg">Exchange Skills</h4>
                  </div>
                  <p className="text-white/90 text-sm">
                    Trade knowledge with peers. Learn guitar, teach coding!
                  </p>
                </div>
                <TrendingUp className="w-5 h-5 text-white/80" />
              </div>
            </button>

            {/* Paid Lessons Card */}
            <button
              onClick={() => navigate('/paid-lesson')}
              className="bg-gradient-to-br from-[#22C55E] to-[#16A34A] rounded-2xl p-6 text-left shadow-lg hover:shadow-xl transition-all"
            >
              <div className="flex items-start justify-between">
                <div className="flex-1">
                  <div className="flex items-center gap-2 mb-2">
                    <GraduationCap className="w-6 h-6 text-white" />
                    <h4 className="text-white text-lg">Find a Teacher</h4>
                  </div>
                  <p className="text-white/90 text-sm">
                    Book professional lessons with verified experts
                  </p>
                </div>
                <Star className="w-5 h-5 text-white/80" />
              </div>
            </button>

            {/* AI Tutor Card */}
            <button
              onClick={() => navigate('/ai-tutor')}
              className="bg-gradient-to-br from-[#06B6D4] to-[#0891B2] rounded-2xl p-6 text-left shadow-lg hover:shadow-xl transition-all"
            >
              <div className="flex items-start justify-between">
                <div className="flex-1">
                  <div className="flex items-center gap-2 mb-2">
                    <Sparkles className="w-6 h-6 text-white" />
                    <h4 className="text-white text-lg">AI Tutor</h4>
                  </div>
                  <p className="text-white/90 text-sm">
                    Learn anything, anytime with your AI assistant
                  </p>
                </div>
                <div className="w-6 h-6 bg-white/20 rounded-full flex items-center justify-center">
                  <Sparkles className="w-4 h-4 text-white" />
                </div>
              </div>
            </button>
          </div>
        </div>

        {/* Recommended for You */}
        <div className="px-6 mt-8 mb-4">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-gray-900">Recommended for You</h3>
            <button className="text-[#4F46E5] text-sm">See all</button>
          </div>

          <div className="space-y-3">
            {recommendations.map((user) => (
              <div
                key={user.id}
                onClick={() => {
                  if (user.type === 'paid') {
                    navigate('/paid-lesson');
                  } else {
                    navigate('/skill-exchange');
                  }
                }}
                className="bg-white rounded-2xl p-4 shadow-sm hover:shadow-md transition-all cursor-pointer"
              >
                <div className="flex items-center gap-4">
                  <div className="w-14 h-14 rounded-full overflow-hidden bg-gray-200 flex-shrink-0">
                    <ImageWithFallback
                      src={user.image}
                      alt={user.name}
                      className="w-full h-full object-cover"
                    />
                  </div>
                  <div className="flex-1 min-w-0">
                    <h4 className="text-gray-900 truncate">{user.name}</h4>
                    <p className="text-gray-600 text-sm truncate">{user.skill}</p>
                    <div className="flex items-center gap-2 mt-1">
                      <div className="flex items-center gap-1">
                        <Star className="w-4 h-4 text-yellow-400 fill-yellow-400" />
                        <span className="text-sm text-gray-700">{user.rating}</span>
                      </div>
                      {user.type === 'paid' && (
                        <span className="text-[#22C55E] text-sm">{user.price}</span>
                      )}
                      {user.type === 'exchange' && user.points && (
                        <span className="text-amber-600 text-sm flex items-center gap-1">
                          <Repeat className="w-3 h-3" />
                          {user.points} pts
                        </span>
                      )}
                    </div>
                  </div>
                  <button
                    className={`px-4 py-2 rounded-xl text-sm ${
                      user.type === 'paid'
                        ? 'bg-[#22C55E] text-white'
                        : 'bg-[#4F46E5] text-white'
                    }`}
                  >
                    {user.type === 'paid' ? 'Book' : 'Connect'}
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      <BottomNav />
    </div>
  );
}