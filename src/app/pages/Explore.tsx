import { Search, TrendingUp, Users, BookOpen } from 'lucide-react';
import { useNavigate } from 'react-router';
import { BottomNav } from '../components/BottomNav';

const categories = [
  { name: 'Languages', icon: '🌍', color: '#4F46E5', count: 124 },
  { name: 'Music', icon: '🎵', color: '#22C55E', count: 98 },
  { name: 'Technology', icon: '💻', color: '#06B6D4', count: 156 },
  { name: 'Arts & Crafts', icon: '🎨', color: '#EAB308', count: 87 },
  { name: 'Fitness', icon: '💪', color: '#EF4444', count: 65 },
  { name: 'Cooking', icon: '🍳', color: '#F59E0B', count: 72 },
];

const trending = [
  { skill: 'Spanish Language', learners: 234, type: 'exchange' },
  { skill: 'Python Programming', learners: 189, type: 'both' },
  { skill: 'Guitar Basics', learners: 156, type: 'paid' },
  { skill: 'Digital Marketing', learners: 142, type: 'exchange' },
];

export default function Explore() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      <div className="max-w-md mx-auto">
        {/* Header */}
        <div className="bg-gradient-to-br from-[#4F46E5] to-[#6366F1] px-6 pt-12 pb-8 rounded-b-3xl shadow-lg">
          <h1 className="text-white text-2xl mb-6">Explore Skills</h1>

          {/* Search Bar */}
          <div className="relative">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              placeholder="Search any skill..."
              className="w-full pl-12 pr-4 py-3 bg-white rounded-2xl focus:outline-none focus:ring-2 focus:ring-[#4F46E5]/20 shadow-md"
            />
          </div>
        </div>

        {/* Categories */}
        <div className="px-6 mt-6">
          <h3 className="text-gray-900 mb-4">Categories</h3>
          <div className="grid grid-cols-2 gap-3">
            {categories.map((category, index) => (
              <button
                key={index}
                onClick={() => navigate('/skill-exchange')}
                className="bg-white rounded-2xl p-4 shadow-sm hover:shadow-md transition-all text-left"
              >
                <div className="flex items-center justify-between mb-2">
                  <span className="text-3xl">{category.icon}</span>
                  <div
                    className="w-2 h-2 rounded-full"
                    style={{ backgroundColor: category.color }}
                  ></div>
                </div>
                <h4 className="text-gray-900 mb-1">{category.name}</h4>
                <p className="text-xs text-gray-500">{category.count} teachers</p>
              </button>
            ))}
          </div>
        </div>

        {/* Trending Skills */}
        <div className="px-6 mt-8">
          <div className="flex items-center gap-2 mb-4">
            <TrendingUp className="w-5 h-5 text-[#4F46E5]" />
            <h3 className="text-gray-900">Trending Skills</h3>
          </div>

          <div className="bg-white rounded-2xl shadow-sm overflow-hidden">
            {trending.map((item, index) => (
              <div
                key={index}
                onClick={() => {
                  if (item.type === 'paid') {
                    navigate('/paid-lesson');
                  } else {
                    navigate('/skill-exchange');
                  }
                }}
                className="px-5 py-4 flex items-center justify-between hover:bg-gray-50 transition-colors cursor-pointer border-b border-gray-100 last:border-b-0"
              >
                <div className="flex-1">
                  <h4 className="text-gray-900 mb-1">{item.skill}</h4>
                  <div className="flex items-center gap-2">
                    <Users className="w-4 h-4 text-gray-400" />
                    <span className="text-sm text-gray-600">{item.learners} learners</span>
                  </div>
                </div>
                <div className="flex flex-col gap-1">
                  {item.type === 'exchange' && (
                    <span className="px-2 py-1 bg-[#4F46E5]/10 text-[#4F46E5] rounded-full text-xs">
                      Exchange
                    </span>
                  )}
                  {item.type === 'paid' && (
                    <span className="px-2 py-1 bg-[#22C55E]/10 text-[#22C55E] rounded-full text-xs">
                      Paid
                    </span>
                  )}
                  {item.type === 'both' && (
                    <>
                      <span className="px-2 py-1 bg-[#4F46E5]/10 text-[#4F46E5] rounded-full text-xs">
                        Exchange
                      </span>
                      <span className="px-2 py-1 bg-[#22C55E]/10 text-[#22C55E] rounded-full text-xs">
                        Paid
                      </span>
                    </>
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Quick Actions */}
        <div className="px-6 mt-8 mb-6">
          <h3 className="text-gray-900 mb-4">Quick Actions</h3>
          <div className="space-y-3">
            <button
              onClick={() => navigate('/ai-tutor')}
              className="w-full bg-gradient-to-br from-[#06B6D4] to-[#0891B2] rounded-2xl p-5 text-left shadow-md hover:shadow-lg transition-all"
            >
              <div className="flex items-center justify-between">
                <div>
                  <h4 className="text-white text-lg mb-1">Try AI Tutor</h4>
                  <p className="text-white/90 text-sm">Learn anything, anytime</p>
                </div>
                <BookOpen className="w-8 h-8 text-white/80" />
              </div>
            </button>

            <button
              onClick={() => navigate('/skill-exchange')}
              className="w-full bg-white rounded-2xl p-5 text-left shadow-sm hover:shadow-md transition-all border-2 border-gray-200"
            >
              <div className="flex items-center justify-between">
                <div>
                  <h4 className="text-gray-900 text-lg mb-1">Start Exchanging</h4>
                  <p className="text-gray-600 text-sm">Find your learning partner</p>
                </div>
                <Users className="w-8 h-8 text-[#4F46E5]" />
              </div>
            </button>
          </div>
        </div>
      </div>

      <BottomNav />
    </div>
  );
}
