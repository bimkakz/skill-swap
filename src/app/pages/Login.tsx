import { useState } from 'react';
import { Mail, ArrowRight, Eye, EyeOff } from 'lucide-react';
import { useNavigate } from 'react-router';
import {
  signInWithPopup,
  GoogleAuthProvider,
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  updateProfile,
} from 'firebase/auth';
import { doc, setDoc, getDoc } from 'firebase/firestore';
import { auth, db } from '../../lib/firebase';

export default function Login() {
  const navigate = useNavigate();
  const [mode, setMode] = useState<'main' | 'email'>('main');
  const [isRegister, setIsRegister] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState('');
  const [showPass, setShowPass] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const goHome = () => navigate('/home');

  const ensureUserDoc = async (uid: string, displayName: string, photoURL?: string) => {
    const ref = doc(db, 'users', uid);
    const snap = await getDoc(ref);
    if (!snap.exists()) {
      await setDoc(ref, { name: displayName, photoUrl: photoURL || '', teaching_skills: [], learning_skills: [], createdAt: new Date() });
    }
  };

  const handleGoogle = async () => {
    setLoading(true);
    setError('');
    try {
      const result = await signInWithPopup(auth, new GoogleAuthProvider());
      await ensureUserDoc(result.user.uid, result.user.displayName || 'User', result.user.photoURL || undefined);
      goHome();
    } catch (e: unknown) {
      setError((e as Error).message);
    } finally {
      setLoading(false);
    }
  };

  const handleEmail = async () => {
    if (!email || !password) return;
    setLoading(true);
    setError('');
    try {
      if (isRegister) {
        const result = await createUserWithEmailAndPassword(auth, email, password);
        if (name) await updateProfile(result.user, { displayName: name });
        await ensureUserDoc(result.user.uid, name || email.split('@')[0]);
      } else {
        await signInWithEmailAndPassword(auth, email, password);
      }
      goHome();
    } catch (e: unknown) {
      const code = (e as { code?: string }).code;
      if (code === 'auth/user-not-found' || code === 'auth/wrong-password') setError('Неверный email или пароль');
      else if (code === 'auth/email-already-in-use') setError('Email уже используется');
      else if (code === 'auth/weak-password') setError('Пароль минимум 6 символов');
      else setError((e as Error).message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#4F46E5]/5 via-white to-[#22C55E]/5 flex flex-col">
      <div className="flex-1 flex flex-col max-w-md mx-auto w-full px-6 py-12">
        {/* Logo */}
        <div className="text-center mb-12 mt-8">
          <div className="inline-flex items-center justify-center w-20 h-20 rounded-3xl bg-gradient-to-br from-[#4F46E5] to-[#22C55E] mb-4 shadow-lg">
            <span className="text-3xl text-white">S</span>
          </div>
          <h1 className="text-4xl text-gray-900 mb-2">SkillSwap</h1>
          <p className="text-gray-600">Learn, teach, and grow together</p>
        </div>

        <div className="flex-1 flex flex-col justify-center space-y-4">
          {mode === 'main' && (
            <>
              <button
                onClick={handleGoogle}
                disabled={loading}
                className="w-full py-4 px-6 rounded-2xl bg-white border-2 border-gray-200 flex items-center justify-center gap-3 hover:border-[#4F46E5] hover:bg-[#4F46E5]/5 transition-all shadow-sm disabled:opacity-50"
              >
                <svg className="w-6 h-6" viewBox="0 0 24 24">
                  <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" />
                  <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" />
                  <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" />
                  <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" />
                </svg>
                <span className="text-gray-700">{loading ? 'Загрузка...' : 'Continue with Google'}</span>
              </button>

              <div className="relative my-2">
                <div className="absolute inset-0 flex items-center">
                  <div className="w-full border-t border-gray-200" />
                </div>
                <div className="relative flex justify-center text-sm">
                  <span className="px-4 bg-transparent text-gray-500">or</span>
                </div>
              </div>

              <button
                onClick={() => setMode('email')}
                className="w-full py-4 px-6 rounded-2xl bg-[#4F46E5] text-white flex items-center justify-center gap-3 hover:bg-[#4338CA] transition-all shadow-lg"
              >
                <Mail className="w-5 h-5" />
                <span>Continue with Email</span>
                <ArrowRight className="w-5 h-5 ml-auto" />
              </button>
            </>
          )}

          {mode === 'email' && (
            <>
              <button onClick={() => { setMode('main'); setError(''); }} className="text-sm text-[#4F46E5] mb-2 text-left">← Назад</button>

              <div className="flex rounded-2xl overflow-hidden border border-gray-200 mb-2">
                <button onClick={() => setIsRegister(false)} className={`flex-1 py-3 text-sm transition-colors ${!isRegister ? 'bg-[#4F46E5] text-white' : 'bg-white text-gray-600'}`}>Войти</button>
                <button onClick={() => setIsRegister(true)} className={`flex-1 py-3 text-sm transition-colors ${isRegister ? 'bg-[#4F46E5] text-white' : 'bg-white text-gray-600'}`}>Регистрация</button>
              </div>

              {isRegister && (
                <input
                  type="text"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  placeholder="Имя"
                  className="w-full px-4 py-3 bg-gray-100 rounded-2xl focus:outline-none focus:ring-2 focus:ring-[#4F46E5]/20"
                />
              )}

              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="Email"
                className="w-full px-4 py-3 bg-gray-100 rounded-2xl focus:outline-none focus:ring-2 focus:ring-[#4F46E5]/20"
              />

              <div className="relative">
                <input
                  type={showPass ? 'text' : 'password'}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  onKeyDown={(e) => e.key === 'Enter' && handleEmail()}
                  placeholder="Пароль"
                  className="w-full px-4 py-3 bg-gray-100 rounded-2xl focus:outline-none focus:ring-2 focus:ring-[#4F46E5]/20 pr-12"
                />
                <button onClick={() => setShowPass((v) => !v)} className="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400">
                  {showPass ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
                </button>
              </div>

              {error && <p className="text-red-500 text-sm px-1">{error}</p>}

              <button
                onClick={handleEmail}
                disabled={loading || !email || !password}
                className="w-full py-4 rounded-2xl bg-[#4F46E5] text-white hover:bg-[#4338CA] transition-all shadow-lg disabled:opacity-50"
              >
                {loading ? 'Загрузка...' : isRegister ? 'Создать аккаунт' : 'Войти'}
              </button>
            </>
          )}
        </div>

        <p className="text-center text-sm text-gray-500 mt-8">
          By continuing, you agree to our{' '}
          <a href="#" className="text-[#4F46E5] hover:underline">Terms</a> and{' '}
          <a href="#" className="text-[#4F46E5] hover:underline">Privacy Policy</a>
        </p>
      </div>
    </div>
  );
}
