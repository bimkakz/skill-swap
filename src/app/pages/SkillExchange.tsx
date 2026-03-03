import { ArrowLeft, Repeat, Star, MessageCircle, ArrowRight, Coins } from 'lucide-react';
import { useNavigate } from 'react-router';
import { BottomNav } from '../components/BottomNav';
import { ImageWithFallback } from '../components/figma/ImageWithFallback';
import { StatusBar } from '../components/StatusBar';

const users = [
  {
    id: 1,
    name: 'Maria Garcia',
    image: 'https://images.unsplash.com/photo-1770564512654-35be546ed257?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx5b3VuZyUyMHdvbWFuJTIwc21pbGluZyUyMGNhc3VhbHxlbnwxfHx8fDE3NzEzODg1MDJ8MA&ixlib=rb-4.1.0&q=80&w=1080',
    offering: ['Spanish', 'Photography', 'Cooking'],
    wanting: ['Web Development', 'Guitar'],
    rating: 4.9,
    exchanges: 12,
    bio: 'Native Spanish speaker and hobby photographer. Love to meet new people!',
    pointsPerHour: 100,
  },
  {
    id: 2,
    name: 'David Kim',
    image: 'https://images.unsplash.com/photo-1764816657425-b3c79b616d14?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtYW4lMjBjYXN1YWwlMjBwb3J0cmFpdCUyMGZyaWVuZGx5fGVufDF8fHx8MTc3MTM2MzM4M3ww&ixlib=rb-4.1.0&q=80&w=1080',
    offering: ['Korean', 'Piano', 'Math Tutoring'],
    wanting: ['French', 'Cooking'],
    rating: 5.0,
    exchanges: 8,
    bio: 'Math teacher by day, musician by night. Always happy to help!',
    pointsPerHour: 150,
  },
  {
    id: 3,
    name: 'Sophie Laurent',
    image: 'https://images.unsplash.com/photo-1623594675959-02360202d4d6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx3b21hbiUyMHNtaWxpbmclMjBwb3J0cmFpdCUyMHByb2Zlc3Npb25hbHxlbnwxfHx8fDE3NzEzMjkyOTJ8MA&ixlib=rb-4.1.0&q=80&w=1080',
    offering: ['French', 'Yoga', 'Graphic Design'],
    wanting: ['Spanish', 'Photography'],
    rating: 4.8,
    exchanges: 15,
    bio: 'Designer and yoga enthusiast. Passionate about learning and sharing!',
    pointsPerHour: 120,
  },
];

export default function SkillExchange() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-md mx-auto">
        {/* Status Bar */}
        <div className="bg-gradient-to-br from-[#4F46E5] to-[#6366F1]">
          <StatusBar theme="dark" />
        </div>

        {/* Header */}
        <div className="bg-gradient-to-br from-[#4F46E5] to-[#6366F1] px-6 pb-6 rounded-b-[32px] shadow-lg">
          <div className="flex items-center gap-4 mb-4">
            <button
              onClick={() => navigate('/home')}
              className="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center hover:bg-white/30 transition-colors"
            >
              <ArrowLeft className="w-5 h-5 text-white" />
            </button>
            <div className="flex-1">
              <h1 className="text-white text-2xl">Skill Exchange</h1>
              <p className="text-white/90 text-sm mt-1">Find your learning partner</p>
            </div>
            <Repeat className="w-8 h-8 text-white/80" />
          </div>
        </div>

        {/* Info Banner */}
        <div className="mx-6 -mt-4 mb-6 bg-white rounded-2xl p-4 shadow-md border-l-4 border-[#4F46E5]">
          <p className="text-sm text-gray-700">
            <span className="font-medium text-[#4F46E5]">How it works:</span> Connect with others
            and exchange skills. You teach something, they teach you something in return!
          </p>
        </div>

        {/* User Cards */}
        <div className="px-6 space-y-4">
          {users.map((user) => (
            <div
              key={user.id}
              className="bg-white rounded-2xl shadow-sm hover:shadow-md transition-all overflow-hidden"
            >
              {/* User Header */}
              <div className="p-5 pb-4">
                <div className="flex items-start gap-4">
                  <div className="w-16 h-16 rounded-full overflow-hidden bg-gray-200 flex-shrink-0">
                    <ImageWithFallback
                      src={user.image}
                      alt={user.name}
                      className="w-full h-full object-cover"
                    />
                  </div>
                  <div className="flex-1 min-w-0">
                    <h3 className="text-gray-900 text-lg">{user.name}</h3>
                    <div className="flex items-center gap-3 mt-1">
                      <div className="flex items-center gap-1">
                        <Star className="w-4 h-4 text-yellow-400 fill-yellow-400" />
                        <span className="text-sm text-gray-700">{user.rating}</span>
                      </div>
                      <span className="text-sm text-gray-500">
                        {user.exchanges} exchanges
                      </span>
                      <div className="flex items-center gap-1 ml-auto">
                        <Coins className="w-4 h-4 text-amber-600" />
                        <span className="text-sm font-semibold text-amber-600">
                          {user.pointsPerHour} pts/hr
                        </span>
                      </div>
                    </div>
                    <p className="text-sm text-gray-600 mt-2 line-clamp-2">{user.bio}</p>
                  </div>
                </div>
              </div>

              {/* Skills Section */}
              <div className="px-5 pb-4 space-y-3">
                {/* Offering */}
                <div>
                  <div className="flex items-center gap-2 mb-2">
                    <div className="w-2 h-2 rounded-full bg-green-500"></div>
                    <span className="text-sm text-gray-600">Offering</span>
                  </div>
                  <div className="flex flex-wrap gap-2">
                    {user.offering.map((skill, index) => (
                      <span
                        key={index}
                        className="px-3 py-1 bg-green-50 text-green-700 rounded-full text-sm border border-green-200"
                      >
                        {skill}
                      </span>
                    ))}
                  </div>
                </div>

                {/* Wanting */}
                <div>
                  <div className="flex items-center gap-2 mb-2">
                    <div className="w-2 h-2 rounded-full bg-blue-500"></div>
                    <span className="text-sm text-gray-600">Looking for</span>
                  </div>
                  <div className="flex flex-wrap gap-2">
                    {user.wanting.map((skill, index) => (
                      <span
                        key={index}
                        className="px-3 py-1 bg-blue-50 text-blue-700 rounded-full text-sm border border-blue-200"
                      >
                        {skill}
                      </span>
                    ))}
                  </div>
                </div>
              </div>

              {/* Actions */}
              <div className="p-4 bg-gray-50 flex gap-3">
                <button
                  onClick={() => navigate('/chat')}
                  className="flex-1 py-3 rounded-xl bg-white border-2 border-gray-200 hover:border-[#4F46E5] hover:bg-[#4F46E5]/5 transition-all flex items-center justify-center gap-2"
                >
                  <MessageCircle className="w-5 h-5 text-gray-700" />
                  <span className="text-gray-700">Message</span>
                </button>
                <button
                  onClick={() => navigate('/chat')}
                  className="flex-1 py-3 rounded-xl bg-[#4F46E5] text-white hover:bg-[#4338CA] transition-all flex items-center justify-center gap-2 shadow-md"
                >
                  <Repeat className="w-5 h-5" />
                  <span>Propose Exchange</span>
                </button>
              </div>
            </div>
          ))}
        </div>

        {/* Load More */}
        <div className="px-6 py-6 flex justify-center">
          <button className="px-6 py-3 rounded-xl bg-white border-2 border-gray-200 hover:border-[#4F46E5] hover:bg-[#4F46E5]/5 transition-all flex items-center gap-2">
            <span className="text-gray-700">Load More</span>
            <ArrowRight className="w-4 h-4 text-gray-700" />
          </button>
        </div>
      </div>

      <BottomNav />
    </div>
  );
}