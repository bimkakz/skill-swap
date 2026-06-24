import { useEffect, useState } from 'react';
import { Search, MessageCircle } from 'lucide-react';
import { useNavigate } from 'react-router';
import { collection, getDocs } from 'firebase/firestore';
import { db } from '../../lib/firebase';
import { useAuth } from '../../lib/AuthContext';
import { BottomNav } from '../components/BottomNav';

interface FirebaseUser {
  id: string;
  name: string;
  photoUrl?: string;
  teaching_skills?: string[];
}

export default function Messages() {
  const navigate = useNavigate();
  const { user: currentUser, loading: authLoading } = useAuth();
  const [users, setUsers] = useState<FirebaseUser[]>([]);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    if (authLoading) return;
    if (!currentUser) { navigate('/login'); return; }

    getDocs(collection(db, 'users'))
      .then((snap) => {
        const list: FirebaseUser[] = snap.docs
          .filter((doc) => doc.id !== currentUser.uid)
          .map((doc) => ({
            id: doc.id,
            name: doc.data().name || doc.data().displayName || 'Unknown',
            photoUrl: doc.data().photoUrl || doc.data().photoURL,
            teaching_skills: doc.data().teaching_skills || [],
          }));
        setUsers(list);
      })
      .catch(() => setError('Не удалось загрузить пользователей'))
      .finally(() => setLoading(false));
  }, [currentUser, authLoading]);

  const filtered = users.filter((u) =>
    u.name.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      <div className="max-w-md mx-auto">
        {/* Header */}
        <div className="bg-white px-6 pt-12 pb-6 rounded-b-3xl shadow-sm">
          <h1 className="text-2xl text-gray-900 mb-6">Messages</h1>
          <div className="relative">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search conversations..."
              className="w-full pl-12 pr-4 py-3 bg-gray-100 rounded-2xl focus:outline-none focus:ring-2 focus:ring-[#4F46E5]/20"
            />
          </div>
        </div>

        <div className="px-6 mt-6 space-y-3">
          {loading && (
            <div className="space-y-3">
              {[1, 2, 3].map((i) => (
                <div key={i} className="bg-white rounded-2xl p-4 shadow-sm animate-pulse">
                  <div className="flex items-center gap-4">
                    <div className="w-14 h-14 rounded-full bg-gray-200" />
                    <div className="flex-1 space-y-2">
                      <div className="h-4 bg-gray-200 rounded w-1/3" />
                      <div className="h-3 bg-gray-100 rounded w-2/3" />
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}

          {error && (
            <div className="text-center py-6 text-red-500 text-sm">{error}</div>
          )}

          {!loading && !error && filtered.map((user) => (
            <div
              key={user.id}
              onClick={() => navigate(`/chat?userId=${user.id}&userName=${encodeURIComponent(user.name)}`)}
              className="bg-white rounded-2xl p-4 shadow-sm hover:shadow-md transition-all cursor-pointer"
            >
              <div className="flex items-center gap-4">
                <div className="w-14 h-14 rounded-full overflow-hidden bg-gradient-to-br from-[#4F46E5] to-[#06B6D4] flex items-center justify-center flex-shrink-0">
                  {user.photoUrl ? (
                    <img src={user.photoUrl} alt={user.name} className="w-full h-full object-cover" />
                  ) : (
                    <span className="text-white text-xl font-semibold">
                      {user.name.charAt(0).toUpperCase()}
                    </span>
                  )}
                </div>

                <div className="flex-1 min-w-0">
                  <h3 className="text-gray-900 truncate">{user.name}</h3>
                  {user.teaching_skills && user.teaching_skills.length > 0 && (
                    <p className="text-sm text-gray-500 truncate">
                      Teaches: {user.teaching_skills.slice(0, 2).join(', ')}
                    </p>
                  )}
                </div>
              </div>
            </div>
          ))}

          {!loading && !error && filtered.length === 0 && (
            <div className="flex flex-col items-center justify-center py-20 px-6">
              <div className="w-20 h-20 rounded-full bg-gray-100 flex items-center justify-center mb-4">
                <MessageCircle className="w-10 h-10 text-gray-400" />
              </div>
              <h3 className="text-gray-900 mb-2">
                {search ? 'Пользователи не найдены' : 'Нет пользователей'}
              </h3>
              <p className="text-gray-600 text-sm text-center">
                {search ? 'Попробуй другой запрос' : 'Зарегистрированные пользователи появятся здесь'}
              </p>
            </div>
          )}
        </div>
      </div>

      <BottomNav />
    </div>
  );
}
