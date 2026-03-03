import { useState } from 'react';
import { ChevronRight, Repeat, DollarSign, Sparkles } from 'lucide-react';
import { useNavigate } from 'react-router';
import { ImageWithFallback } from '../components/figma/ImageWithFallback';

const slides = [
  {
    title: 'Exchange Skills',
    description: 'Swap knowledge with others. Learn guitar, teach coding, and build meaningful connections.',
    icon: Repeat,
    color: '#4F46E5',
    image: 'https://images.unsplash.com/photo-1767143074134-9fbf03a8f2c1?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwZW9wbGUlMjBsZWFybmluZyUyMGV4Y2hhbmdpbmclMjBza2lsbHN8ZW58MXx8fHwxNzcxMzg4NDE3fDA&ixlib=rb-4.1.0&q=80&w=1080',
  },
  {
    title: 'Paid Lessons',
    description: 'Learn from expert teachers. Book one-on-one sessions at your convenience.',
    icon: DollarSign,
    color: '#22C55E',
    image: 'https://images.unsplash.com/photo-1758685848208-e108b6af94cc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx0ZWFjaGVyJTIwc3R1ZGVudCUyMG9ubGluZSUyMGVkdWNhdGlvbnxlbnwxfHx8fDE3NzEzODg0MTd8MA&ixlib=rb-4.1.0&q=80&w=1080',
  },
  {
    title: 'Learn with AI',
    description: 'Your personal AI tutor is ready 24/7. Get instant answers and personalized lessons.',
    icon: Sparkles,
    color: '#06B6D4',
    image: 'https://images.unsplash.com/photo-1767716134849-5e5abb7bf59b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxhcnRpZmljaWFsJTIwaW50ZWxsaWdlbmNlJTIwcm9ib3QlMjBmcmllbmRseXxlbnwxfHx8fDE3NzEzODg0MTh8MA&ixlib=rb-4.1.0&q=80&w=1080',
  },
];

export default function Onboarding() {
  const [currentSlide, setCurrentSlide] = useState(0);
  const navigate = useNavigate();
  const slide = slides[currentSlide];
  const Icon = slide.icon;

  const handleNext = () => {
    if (currentSlide < slides.length - 1) {
      setCurrentSlide(currentSlide + 1);
    } else {
      navigate('/login');
    }
  };

  const handleSkip = () => {
    navigate('/login');
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-white to-gray-50 flex flex-col">
      <div className="flex-1 flex flex-col max-w-md mx-auto w-full px-6 py-8">
        {/* Skip button */}
        <div className="flex justify-end mb-4">
          <button
            onClick={handleSkip}
            className="text-gray-500 text-sm px-4 py-2 rounded-full hover:bg-gray-100 transition-colors"
          >
            Skip
          </button>
        </div>

        {/* Image with icon overlay */}
        <div className="relative mb-8 flex-shrink-0">
          <div className="w-full aspect-square rounded-3xl overflow-hidden bg-gray-100">
            <ImageWithFallback
              src={slide.image}
              alt={slide.title}
              className="w-full h-full object-cover"
            />
          </div>
          <div
            className="absolute -bottom-6 left-1/2 -translate-x-1/2 w-20 h-20 rounded-full flex items-center justify-center shadow-lg"
            style={{ backgroundColor: slide.color }}
          >
            <Icon className="w-10 h-10 text-white" />
          </div>
        </div>

        {/* Content */}
        <div className="flex-1 flex flex-col items-center text-center mt-12">
          <h1 className="text-3xl mb-4 text-gray-900">{slide.title}</h1>
          <p className="text-gray-600 text-lg leading-relaxed mb-8 px-4">
            {slide.description}
          </p>

          {/* Dots indicator */}
          <div className="flex gap-2 mb-8">
            {slides.map((_, index) => (
              <div
                key={index}
                className={`h-2 rounded-full transition-all ${
                  index === currentSlide
                    ? 'w-8 bg-[#4F46E5]'
                    : 'w-2 bg-gray-300'
                }`}
              />
            ))}
          </div>
        </div>

        {/* Button */}
        <button
          onClick={handleNext}
          className="w-full py-4 rounded-2xl text-white flex items-center justify-center gap-2 shadow-lg hover:shadow-xl transition-all"
          style={{ backgroundColor: slide.color }}
        >
          <span className="text-lg">
            {currentSlide < slides.length - 1 ? 'Next' : 'Get Started'}
          </span>
          <ChevronRight className="w-5 h-5" />
        </button>
      </div>
    </div>
  );
}
