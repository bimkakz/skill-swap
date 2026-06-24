import { useEffect, useRef, useState } from 'react';
import { ArrowLeft, Send, Phone, Video, MoreVertical } from 'lucide-react';
import { useNavigate, useSearchParams } from 'react-router';
import {
  collection,
  addDoc,
  query,
  orderBy,
  onSnapshot,
  serverTimestamp,
  Timestamp,
} from 'firebase/firestore';
import { db } from '../../lib/firebase';
import { useAuth } from '../../lib/AuthContext';

interface Message {
  id: string;
  senderId: string;
  text: string;
  timestamp: Timestamp | null;
}

function getChatId(uid1: string, uid2: string) {
  return [uid1, uid2].sort().join('_');
}

export default function Chat() {
  const navigate = useNavigate();
  const [params] = useSearchParams();
  const { user: currentUser } = useAuth();

  const receiverId = params.get('userId') || '';
  const receiverName = params.get('userName') || 'User';

  const [messages, setMessages] = useState<Message[]>([]);
  const [input, setInput] = useState('');
  const bottomRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!currentUser || !receiverId) return;

    const chatId = getChatId(currentUser.uid, receiverId);
    const q = query(
      collection(db, 'chats', chatId, 'messages'),
      orderBy('timestamp', 'asc')
    );

    const unsub = onSnapshot(q, (snap) => {
      setMessages(
        snap.docs.map((d) => ({
          id: d.id,
          senderId: d.data().senderId,
          text: d.data().text,
          timestamp: d.data().timestamp ?? null,
        }))
      );
    });

    return unsub;
  }, [currentUser, receiverId]);

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  const handleSend = async () => {
    if (!input.trim() || !currentUser || !receiverId) return;
    const text = input.trim();
    setInput('');

    const chatId = getChatId(currentUser.uid, receiverId);
    await addDoc(collection(db, 'chats', chatId, 'messages'), {
      senderId: currentUser.uid,
      receiverId,
      text,
      type: 'text',
      timestamp: serverTimestamp(),
    });
  };

  const formatTime = (ts: Timestamp | null) => {
    if (!ts) return '';
    return ts.toDate().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  };

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      <div className="max-w-md mx-auto w-full flex flex-col h-screen">
        {/* Header */}
        <div className="bg-white px-6 pt-12 pb-4 shadow-sm flex-shrink-0 border-b border-gray-200">
          <div className="flex items-center gap-4">
            <button
              onClick={() => navigate(-1)}
              className="w-10 h-10 rounded-full hover:bg-gray-100 flex items-center justify-center transition-colors"
            >
              <ArrowLeft className="w-5 h-5 text-gray-700" />
            </button>

            <div className="flex-1 flex items-center gap-3 min-w-0">
              <div className="w-10 h-10 rounded-full bg-gradient-to-br from-[#4F46E5] to-[#06B6D4] flex items-center justify-center flex-shrink-0">
                <span className="text-white font-semibold">
                  {receiverName.charAt(0).toUpperCase()}
                </span>
              </div>
              <div className="flex-1 min-w-0">
                <h2 className="text-gray-900 truncate">{receiverName}</h2>
              </div>
            </div>

            <div className="flex items-center gap-2">
              <button
                onClick={() => navigate(`/call?type=audio&user=${encodeURIComponent(receiverName)}&room=skillswap-${receiverId}`)}
                className="w-10 h-10 rounded-full hover:bg-gray-100 flex items-center justify-center transition-colors"
              >
                <Phone className="w-5 h-5 text-gray-700" />
              </button>
              <button
                onClick={() => navigate(`/call?type=video&user=${encodeURIComponent(receiverName)}&room=skillswap-${receiverId}`)}
                className="w-10 h-10 rounded-full hover:bg-gray-100 flex items-center justify-center transition-colors"
              >
                <Video className="w-5 h-5 text-gray-700" />
              </button>
              <button className="w-10 h-10 rounded-full hover:bg-gray-100 flex items-center justify-center transition-colors">
                <MoreVertical className="w-5 h-5 text-gray-700" />
              </button>
            </div>
          </div>
        </div>

        {/* Messages */}
        <div className="flex-1 overflow-y-auto px-6 py-4 space-y-3">
          {messages.length === 0 && (
            <div className="text-center py-16">
              <div className="w-16 h-16 rounded-full bg-gradient-to-br from-[#4F46E5] to-[#06B6D4] flex items-center justify-center mx-auto mb-4">
                <span className="text-white text-2xl font-semibold">
                  {receiverName.charAt(0).toUpperCase()}
                </span>
              </div>
              <p className="text-gray-900 font-medium">{receiverName}</p>
              <p className="text-gray-500 text-sm mt-1">Начни переписку</p>
            </div>
          )}

          {messages.map((message) => {
            const isMe = message.senderId === currentUser?.uid;
            return (
              <div key={message.id} className={`flex ${isMe ? 'justify-end' : 'justify-start'}`}>
                <div className={`max-w-[75%] flex flex-col gap-1 ${isMe ? 'items-end' : 'items-start'}`}>
                  <div
                    className={`rounded-2xl px-4 py-3 ${
                      isMe
                        ? 'bg-[#4F46E5] text-white rounded-br-sm'
                        : 'bg-white text-gray-800 rounded-bl-sm shadow-sm'
                    }`}
                  >
                    <p className="text-sm leading-relaxed">{message.text}</p>
                  </div>
                  <span className="text-xs text-gray-400 px-2">
                    {formatTime(message.timestamp)}
                  </span>
                </div>
              </div>
            );
          })}

          <div ref={bottomRef} />
        </div>

        {/* Input */}
        <div className="px-6 py-4 bg-white border-t border-gray-200 flex-shrink-0">
          <div className="flex items-end gap-3">
            <input
              type="text"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && handleSend()}
              placeholder="Type a message..."
              className="flex-1 px-4 py-3 bg-gray-100 rounded-2xl focus:outline-none focus:ring-2 focus:ring-[#4F46E5]/20"
            />
            <button
              onClick={handleSend}
              disabled={!input.trim()}
              className="w-12 h-12 rounded-full bg-[#4F46E5] flex items-center justify-center hover:bg-[#4338CA] transition-all disabled:opacity-50 disabled:cursor-not-allowed shadow-md"
            >
              <Send className="w-5 h-5 text-white" />
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
