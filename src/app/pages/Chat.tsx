import { useState } from 'react';
import { ArrowLeft, Send, MoreVertical, Phone, Video } from 'lucide-react';
import { useNavigate } from 'react-router';
import { ImageWithFallback } from '../components/figma/ImageWithFallback';

const initialMessages = [
  {
    id: 1,
    sender: 'other',
    text: "Hi! I saw you're interested in learning Spanish. I'd love to help!",
    time: '10:30 AM',
  },
  {
    id: 2,
    sender: 'me',
    text: "That's great! I've been wanting to learn for a while. How does the exchange work?",
    time: '10:32 AM',
  },
  {
    id: 3,
    sender: 'other',
    text: "We can do weekly sessions where I teach you Spanish and you teach me web development. 1 hour each!",
    time: '10:33 AM',
  },
  {
    id: 4,
    sender: 'me',
    text: 'Sounds perfect! When would you like to start?',
    time: '10:35 AM',
  },
];

export default function Chat() {
  const navigate = useNavigate();
  const [messages, setMessages] = useState(initialMessages);
  const [input, setInput] = useState('');

  const otherUser = {
    name: 'Maria Garcia',
    image: 'https://images.unsplash.com/photo-1770564512654-35be546ed257?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx5b3VuZyUyMHdvbWFuJTIwc21pbGluZyUyMGNhc3VhbHxlbnwxfHx8fDE3NzEzODg1MDJ8MA&ixlib=rb-4.1.0&q=80&w=1080',
    online: true,
  };

  const handleSend = () => {
    if (input.trim()) {
      setMessages([
        ...messages,
        {
          id: messages.length + 1,
          sender: 'me',
          text: input,
          time: 'Just now',
        },
      ]);
      setInput('');
    }
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
              <div className="relative">
                <div className="w-10 h-10 rounded-full overflow-hidden bg-gray-200">
                  <ImageWithFallback
                    src={otherUser.image}
                    alt={otherUser.name}
                    className="w-full h-full object-cover"
                  />
                </div>
                {otherUser.online && (
                  <div className="absolute bottom-0 right-0 w-3 h-3 bg-green-500 rounded-full border-2 border-white"></div>
                )}
              </div>
              <div className="flex-1 min-w-0">
                <h2 className="text-gray-900 truncate">{otherUser.name}</h2>
                <p className="text-xs text-green-600">Online</p>
              </div>
            </div>

            <div className="flex items-center gap-2">
              <button className="w-10 h-10 rounded-full hover:bg-gray-100 flex items-center justify-center transition-colors">
                <Phone className="w-5 h-5 text-gray-700" />
              </button>
              <button className="w-10 h-10 rounded-full hover:bg-gray-100 flex items-center justify-center transition-colors">
                <Video className="w-5 h-5 text-gray-700" />
              </button>
              <button className="w-10 h-10 rounded-full hover:bg-gray-100 flex items-center justify-center transition-colors">
                <MoreVertical className="w-5 h-5 text-gray-700" />
              </button>
            </div>
          </div>
        </div>

        {/* Messages */}
        <div className="flex-1 overflow-y-auto px-6 py-4 space-y-4">
          <div className="text-center py-4">
            <span className="text-xs text-gray-500 bg-gray-200 px-3 py-1 rounded-full">
              Today
            </span>
          </div>

          {messages.map((message) => (
            <div
              key={message.id}
              className={`flex ${message.sender === 'me' ? 'justify-end' : 'justify-start'}`}
            >
              <div
                className={`max-w-[75%] ${
                  message.sender === 'me' ? 'items-end' : 'items-start'
                } flex flex-col gap-1`}
              >
                <div
                  className={`rounded-2xl px-4 py-3 ${
                    message.sender === 'me'
                      ? 'bg-[#4F46E5] text-white rounded-br-sm'
                      : 'bg-white text-gray-800 rounded-bl-sm shadow-sm'
                  }`}
                >
                  <p className="text-sm leading-relaxed">{message.text}</p>
                </div>
                <span className="text-xs text-gray-500 px-2">{message.time}</span>
              </div>
            </div>
          ))}
        </div>

        {/* Input Area */}
        <div className="px-6 py-4 bg-white border-t border-gray-200 flex-shrink-0">
          <div className="flex items-end gap-3">
            <input
              type="text"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyPress={(e) => e.key === 'Enter' && handleSend()}
              placeholder="Type a message..."
              className="flex-1 px-4 py-3 bg-gray-100 rounded-2xl focus:outline-none focus:ring-2 focus:ring-[#4F46E5]/20 resize-none"
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
