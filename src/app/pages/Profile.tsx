import { Settings, Star, Repeat, GraduationCap, Award, Edit, ChevronRight, LogOut, Coins, TrendingUp, TrendingDown } from 'lucide-react';
import { useNavigate } from 'react-router';
import { BottomNav } from '../components/BottomNav';
import { PointsBalance } from '../components/PointsBalance';
import { StatusBar } from '../components/StatusBar';

export default function Profile() {
  const navigate = useNavigate();

  const user = {
    name: 'Alex Johnson',
    email: 'alex.johnson@email.com',
    memberSince: 'February 2026',
    rating: 4.9,
    skillsOffering: ['Web Development', 'React', 'UI/UX Design'],
    skillsLearning: ['Spanish', 'Guitar', 'Photography'],
  };

  const stats = [
    { label: 'Exchanges', value: 12, icon: Repeat, color: '#4F46E5' },
    { label: 'Lessons Taken', value: 8, icon: GraduationCap, color: '#22C55E' },
    { label: 'Rating', value: '4.9', icon: Star, color: '#EAB308' },
  ];

  const pointsHistory = [
    { id: 1, type: 'earned', amount: 100, description: 'Taught React to Maria', date: '2 hours ago' },
    { id: 2, type: 'spent', amount: 50, description: 'Learned Japanese from Sarah', date: 'Yesterday' },
    { id: 3, type: 'earned', amount: 75, description: 'Taught UI/UX to James', date: '2 days ago' },
    { id: 4, type: 'bonus', amount: 50, description: 'Welcome bonus', date: '1 week ago' },
  ];

  const menuItems = [
    { label: 'Edit Profile', icon: Edit, action: () => {} },
    { label: 'My Exchanges', icon: Repeat, action: () => navigate('/skill-exchange') },
    { label: 'My Lessons', icon: GraduationCap, action: () => navigate('/paid-lesson') },
    { label: 'Achievements', icon: Award, action: () => {} },
    { label: 'Settings', icon: Settings, action: () => {} },
  ];

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-md mx-auto">
        {/* Status Bar */}
        <div className="bg-gradient-to-br from-[#4F46E5] to-[#6366F1]">
          <StatusBar theme="dark" />
        </div>

        {/* Header */}
        <div className="bg-gradient-to-br from-[#4F46E5] to-[#6366F1] px-6 pb-20 rounded-b-[32px] shadow-lg">
          <div className="flex justify-end mb-4">
            <button className="w-10 h-10 rounded-full bg-white/20 hover:bg-white/30 flex items-center justify-center transition-colors">
              <Settings className="w-5 h-5 text-white" />
            </button>
          </div>

          <div className="flex flex-col items-center text-center">
            <div className="w-24 h-24 rounded-full bg-gradient-to-br from-white to-gray-100 flex items-center justify-center text-4xl text-[#4F46E5] shadow-xl mb-4">
              AJ
            </div>
            <h1 className="text-white text-2xl mb-1">{user.name}</h1>
            <p className="text-white/80 text-sm mb-2">{user.email}</p>
            <p className="text-white/70 text-xs">Member since {user.memberSince}</p>
          </div>
        </div>

        {/* Stats Cards */}
        <div className="px-6 -mt-12 mb-6">
          <div className="bg-white rounded-2xl shadow-lg p-5">
            <div className="grid grid-cols-3 gap-4">
              {stats.map((stat, index) => (
                <div key={index} className="text-center">
                  <div
                    className="w-12 h-12 rounded-full mx-auto mb-2 flex items-center justify-center"
                    style={{ backgroundColor: `${stat.color}15` }}
                  >
                    <stat.icon className="w-6 h-6" style={{ color: stat.color }} />
                  </div>
                  <div className="text-2xl text-gray-900 mb-1">{stat.value}</div>
                  <div className="text-xs text-gray-600">{stat.label}</div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Points Balance */}
        <div className="px-6 mb-6">
          <div className="bg-gradient-to-br from-amber-50 to-orange-50 rounded-2xl shadow-sm p-5 border border-amber-200">
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2">
                <Coins className="w-5 h-5 text-amber-600" />
                <h3 className="text-gray-900">SkillSwap Points</h3>
              </div>
              <PointsBalance points={1250} size="medium" />
            </div>
            <p className="text-sm text-gray-600 mb-4">
              Earn points by teaching skills and spend them to learn from others
            </p>

            {/* Points History */}
            <div className="space-y-3">
              <div className="flex items-center justify-between text-sm">
                <span className="text-gray-700 font-medium">Recent Activity</span>
                <button className="text-[#4F46E5]">View All</button>
              </div>
              {pointsHistory.map((transaction) => (
                <div
                  key={transaction.id}
                  className="flex items-start gap-3 bg-white rounded-xl p-3 border border-amber-100"
                >
                  <div
                    className={`w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 ${
                      transaction.type === 'earned'
                        ? 'bg-green-100'
                        : transaction.type === 'bonus'
                        ? 'bg-purple-100'
                        : 'bg-red-100'
                    }`}
                  >
                    {transaction.type === 'earned' || transaction.type === 'bonus' ? (
                      <TrendingUp
                        className={`w-4 h-4 ${
                          transaction.type === 'bonus' ? 'text-purple-600' : 'text-green-600'
                        }`}
                      />
                    ) : (
                      <TrendingDown className="w-4 h-4 text-red-600" />
                    )}
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm text-gray-900 truncate">{transaction.description}</p>
                    <p className="text-xs text-gray-500">{transaction.date}</p>
                  </div>
                  <div
                    className={`text-sm font-semibold ${
                      transaction.type === 'spent' ? 'text-red-600' : 'text-green-600'
                    }`}
                  >
                    {transaction.type === 'spent' ? '-' : '+'}
                    {transaction.amount}
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Skills Section */}
        <div className="px-6 mb-6">
          <div className="bg-white rounded-2xl shadow-sm p-5">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-gray-900">My Skills</h3>
              <button className="text-[#4F46E5] text-sm">Edit</button>
            </div>

            {/* Offering */}
            <div className="mb-4">
              <div className="flex items-center gap-2 mb-2">
                <div className="w-2 h-2 rounded-full bg-green-500"></div>
                <span className="text-sm text-gray-600">Teaching</span>
              </div>
              <div className="flex flex-wrap gap-2">
                {user.skillsOffering.map((skill, index) => (
                  <span
                    key={index}
                    className="px-3 py-1.5 bg-green-50 text-green-700 rounded-full text-sm border border-green-200"
                  >
                    {skill}
                  </span>
                ))}
                <button className="px-3 py-1.5 bg-gray-100 text-gray-600 rounded-full text-sm border border-gray-200 hover:bg-gray-200 transition-colors">
                  + Add
                </button>
              </div>
            </div>

            {/* Learning */}
            <div>
              <div className="flex items-center gap-2 mb-2">
                <div className="w-2 h-2 rounded-full bg-blue-500"></div>
                <span className="text-sm text-gray-600">Learning</span>
              </div>
              <div className="flex flex-wrap gap-2">
                {user.skillsLearning.map((skill, index) => (
                  <span
                    key={index}
                    className="px-3 py-1.5 bg-blue-50 text-blue-700 rounded-full text-sm border border-blue-200"
                  >
                    {skill}
                  </span>
                ))}
                <button className="px-3 py-1.5 bg-gray-100 text-gray-600 rounded-full text-sm border border-gray-200 hover:bg-gray-200 transition-colors">
                  + Add
                </button>
              </div>
            </div>
          </div>
        </div>

        {/* Menu Items */}
        <div className="px-6 mb-6">
          <div className="bg-white rounded-2xl shadow-sm overflow-hidden">
            {menuItems.map((item, index) => (
              <button
                key={index}
                onClick={item.action}
                className="w-full px-5 py-4 flex items-center gap-4 hover:bg-gray-50 transition-colors border-b border-gray-100 last:border-b-0"
              >
                <div className="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center">
                  <item.icon className="w-5 h-5 text-gray-600" />
                </div>
                <span className="flex-1 text-left text-gray-900">{item.label}</span>
                <ChevronRight className="w-5 h-5 text-gray-400" />
              </button>
            ))}
          </div>
        </div>

        {/* Logout Button */}
        <div className="px-6 mb-8">
          <button
            onClick={() => navigate('/login')}
            className="w-full px-5 py-4 bg-white rounded-2xl shadow-sm flex items-center justify-center gap-3 text-red-600 hover:bg-red-50 transition-colors"
          >
            <LogOut className="w-5 h-5" />
            <span>Log Out</span>
          </button>
        </div>
      </div>

      <BottomNav />
    </div>
  );
}