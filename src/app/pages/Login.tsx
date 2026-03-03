import { Mail, ArrowRight } from 'lucide-react';
import { useNavigate } from 'react-router';

export default function Login() {
  const navigate = useNavigate();

  const handleLogin = () => {
    navigate('/home');
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#4F46E5]/5 via-white to-[#22C55E]/5 flex flex-col">
      <div className="flex-1 flex flex-col max-w-md mx-auto w-full px-6 py-12">
        {/* Logo/Brand */}
        <div className="text-center mb-12 mt-8">
          <div className="inline-flex items-center justify-center w-20 h-20 rounded-3xl bg-gradient-to-br from-[#4F46E5] to-[#22C55E] mb-4 shadow-lg">
            <span className="text-3xl text-white">S</span>
          </div>
          <h1 className="text-4xl text-gray-900 mb-2">SkillSwap</h1>
          <p className="text-gray-600">Learn, teach, and grow together</p>
        </div>

        {/* Login Options */}
        <div className="flex-1 flex flex-col justify-center space-y-4">
          <button
            onClick={handleLogin}
            className="w-full py-4 px-6 rounded-2xl bg-white border-2 border-gray-200 flex items-center justify-center gap-3 hover:border-[#4F46E5] hover:bg-[#4F46E5]/5 transition-all shadow-sm"
          >
            <svg className="w-6 h-6" viewBox="0 0 24 24">
              <path
                fill="#4285F4"
                d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
              />
              <path
                fill="#34A853"
                d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
              />
              <path
                fill="#FBBC05"
                d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
              />
              <path
                fill="#EA4335"
                d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
              />
            </svg>
            <span className="text-gray-700">Continue with Google</span>
          </button>

          <button
            onClick={handleLogin}
            className="w-full py-4 px-6 rounded-2xl bg-black text-white flex items-center justify-center gap-3 hover:bg-gray-800 transition-all shadow-sm"
          >
            <svg className="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
              <path d="M17.05 20.28c-.98.95-2.05.8-3.08.35-1.09-.46-2.09-.48-3.24 0-1.44.62-2.2.44-3.06-.35C2.79 15.25 3.51 7.59 9.05 7.31c1.35.07 2.29.74 3.08.8 1.18-.24 2.31-.93 3.57-.84 1.51.12 2.65.72 3.4 1.8-3.12 1.87-2.38 5.98.48 7.13-.57 1.5-1.31 2.99-2.54 4.09l.01-.01zM12.03 7.25c-.15-2.23 1.66-4.07 3.74-4.25.29 2.58-2.34 4.5-3.74 4.25z" />
            </svg>
            <span>Continue with Apple</span>
          </button>

          <div className="relative my-6">
            <div className="absolute inset-0 flex items-center">
              <div className="w-full border-t border-gray-200"></div>
            </div>
            <div className="relative flex justify-center text-sm">
              <span className="px-4 bg-white text-gray-500">or</span>
            </div>
          </div>

          <button
            onClick={handleLogin}
            className="w-full py-4 px-6 rounded-2xl bg-[#4F46E5] text-white flex items-center justify-center gap-3 hover:bg-[#4338CA] transition-all shadow-lg hover:shadow-xl"
          >
            <Mail className="w-5 h-5" />
            <span>Continue with Email</span>
            <ArrowRight className="w-5 h-5 ml-auto" />
          </button>
        </div>

        {/* Footer */}
        <p className="text-center text-sm text-gray-500 mt-8">
          By continuing, you agree to our{' '}
          <a href="#" className="text-[#4F46E5] hover:underline">
            Terms
          </a>{' '}
          and{' '}
          <a href="#" className="text-[#4F46E5] hover:underline">
            Privacy Policy
          </a>
        </p>
      </div>
    </div>
  );
}
