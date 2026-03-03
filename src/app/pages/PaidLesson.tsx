import { ArrowLeft, Star, Clock, Video, Calendar, BadgeCheck, Award } from 'lucide-react';
import { useNavigate } from 'react-router';
import { BottomNav } from '../components/BottomNav';
import { ImageWithFallback } from '../components/figma/ImageWithFallback';

export default function PaidLesson() {
  const navigate = useNavigate();

  const teacher = {
    name: 'Dr. Emily Rodriguez',
    image: 'https://images.unsplash.com/photo-1544972917-3529b113a469?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwcm9mZXNzaW9uYWwlMjB0ZWFjaGVyJTIwcG9ydHJhaXR8ZW58MXx8fHwxNzcxMzMzMzA3fDA&ixlib=rb-4.1.0&q=80&w=1080',
    specialty: 'Data Science & Python',
    rating: 5.0,
    reviews: 124,
    students: 380,
    pricePerHour: 45,
    responseTime: '< 2 hours',
    bio: 'PhD in Computer Science with 10+ years of teaching experience. Specialized in making complex concepts simple and engaging.',
    languages: ['English', 'Spanish'],
    certifications: [
      'PhD Computer Science - MIT',
      'Google Certified Data Engineer',
      'AWS Machine Learning Specialist',
    ],
  };

  const availability = [
    { day: 'Today', time: '3:00 PM', available: true },
    { day: 'Today', time: '5:00 PM', available: true },
    { day: 'Tomorrow', time: '10:00 AM', available: true },
    { day: 'Tomorrow', time: '2:00 PM', available: false },
  ];

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      <div className="max-w-md mx-auto">
        {/* Header with Image */}
        <div className="relative">
          <div className="h-48 bg-gradient-to-br from-[#22C55E] to-[#16A34A]"></div>
          <button
            onClick={() => navigate('/home')}
            className="absolute top-12 left-6 w-10 h-10 rounded-full bg-black/30 backdrop-blur-sm flex items-center justify-center hover:bg-black/50 transition-colors"
          >
            <ArrowLeft className="w-5 h-5 text-white" />
          </button>

          {/* Profile Card */}
          <div className="absolute -bottom-16 left-6 right-6">
            <div className="bg-white rounded-2xl shadow-lg p-5">
              <div className="flex gap-4">
                <div className="w-20 h-20 rounded-2xl overflow-hidden bg-gray-200 flex-shrink-0 border-4 border-white shadow-md">
                  <ImageWithFallback
                    src={teacher.image}
                    alt={teacher.name}
                    className="w-full h-full object-cover"
                  />
                </div>
                <div className="flex-1 min-w-0">
                  <div className="flex items-start gap-2">
                    <h2 className="text-xl text-gray-900">{teacher.name}</h2>
                    <BadgeCheck className="w-5 h-5 text-[#22C55E] flex-shrink-0" />
                  </div>
                  <p className="text-gray-600 text-sm mt-1">{teacher.specialty}</p>
                  <div className="flex items-center gap-3 mt-2">
                    <div className="flex items-center gap-1">
                      <Star className="w-4 h-4 text-yellow-400 fill-yellow-400" />
                      <span className="text-sm text-gray-900">{teacher.rating}</span>
                      <span className="text-sm text-gray-500">({teacher.reviews})</span>
                    </div>
                    <span className="text-sm text-gray-500">
                      {teacher.students} students
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Content */}
        <div className="mt-20 px-6 space-y-6">
          {/* Price Card */}
          <div className="bg-gradient-to-br from-[#22C55E] to-[#16A34A] rounded-2xl p-5 text-white shadow-md">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-white/90 text-sm mb-1">Price per hour</p>
                <div className="flex items-baseline gap-2">
                  <span className="text-4xl">${teacher.pricePerHour}</span>
                  <span className="text-white/80 text-lg">/hr</span>
                </div>
              </div>
              <div className="text-right">
                <div className="flex items-center gap-2 justify-end mb-1">
                  <Clock className="w-4 h-4" />
                  <span className="text-sm">{teacher.responseTime}</span>
                </div>
                <div className="flex items-center gap-2 justify-end">
                  <Video className="w-4 h-4" />
                  <span className="text-sm">Video lessons</span>
                </div>
              </div>
            </div>
          </div>

          {/* About */}
          <div className="bg-white rounded-2xl p-5 shadow-sm">
            <h3 className="text-gray-900 mb-3">About</h3>
            <p className="text-gray-600 text-sm leading-relaxed">{teacher.bio}</p>
            <div className="mt-4 flex items-center gap-2">
              <span className="text-sm text-gray-600">Languages:</span>
              {teacher.languages.map((lang, index) => (
                <span
                  key={index}
                  className="px-3 py-1 bg-gray-100 text-gray-700 rounded-full text-sm"
                >
                  {lang}
                </span>
              ))}
            </div>
          </div>

          {/* Certifications */}
          <div className="bg-white rounded-2xl p-5 shadow-sm">
            <div className="flex items-center gap-2 mb-3">
              <Award className="w-5 h-5 text-[#22C55E]" />
              <h3 className="text-gray-900">Certifications</h3>
            </div>
            <div className="space-y-2">
              {teacher.certifications.map((cert, index) => (
                <div key={index} className="flex items-center gap-2 text-sm text-gray-700">
                  <div className="w-1.5 h-1.5 rounded-full bg-[#22C55E]"></div>
                  <span>{cert}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Availability */}
          <div className="bg-white rounded-2xl p-5 shadow-sm">
            <div className="flex items-center gap-2 mb-4">
              <Calendar className="w-5 h-5 text-[#22C55E]" />
              <h3 className="text-gray-900">Available Times</h3>
            </div>
            <div className="grid grid-cols-2 gap-3">
              {availability.map((slot, index) => (
                <button
                  key={index}
                  disabled={!slot.available}
                  className={`p-3 rounded-xl text-sm transition-all ${
                    slot.available
                      ? 'bg-[#22C55E]/10 text-[#22C55E] border-2 border-[#22C55E]/30 hover:bg-[#22C55E]/20'
                      : 'bg-gray-100 text-gray-400 border-2 border-gray-200 cursor-not-allowed'
                  }`}
                >
                  <div className="font-medium">{slot.day}</div>
                  <div className="text-xs mt-1">{slot.time}</div>
                </button>
              ))}
            </div>
            <button className="w-full mt-3 py-2 text-[#22C55E] text-sm hover:bg-[#22C55E]/5 rounded-xl transition-colors">
              View all availability
            </button>
          </div>

          {/* Reviews Preview */}
          <div className="bg-white rounded-2xl p-5 shadow-sm">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-gray-900">Student Reviews</h3>
              <button className="text-[#22C55E] text-sm">View all</button>
            </div>
            <div className="space-y-4">
              <div>
                <div className="flex items-center gap-2 mb-2">
                  <div className="flex">
                    {[...Array(5)].map((_, i) => (
                      <Star key={i} className="w-4 h-4 text-yellow-400 fill-yellow-400" />
                    ))}
                  </div>
                  <span className="text-sm text-gray-600">Jessica M.</span>
                </div>
                <p className="text-sm text-gray-600">
                  "Excellent teacher! Made Python easy to understand. Highly recommend!"
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Fixed Bottom Button */}
        <div className="fixed bottom-20 left-0 right-0 px-6 py-4 bg-white border-t border-gray-200">
          <div className="max-w-md mx-auto">
            <button
              onClick={() => navigate('/chat')}
              className="w-full py-4 rounded-2xl bg-gradient-to-r from-[#22C55E] to-[#16A34A] text-white shadow-lg hover:shadow-xl transition-all"
            >
              Book Lesson - ${teacher.pricePerHour}/hr
            </button>
          </div>
        </div>
      </div>

      <BottomNav />
    </div>
  );
}
