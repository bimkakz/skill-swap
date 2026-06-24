import { useState, useRef, useEffect } from 'react';
import { Send, Sparkles, BookOpen, HelpCircle, FileQuestion, ArrowLeft } from 'lucide-react';
import { useNavigate } from 'react-router';
import { BottomNav } from '../components/BottomNav';

const GROQ_API_KEY = import.meta.env.VITE_GROQ_API_KEY as string;
const GROQ_API_URL = 'https://api.groq.com/openai/v1/chat/completions';

const SYSTEM_PROMPT = `You are an AI tutor on the SkillSwap platform — a place where people exchange skills with each other.
Your goal is to help users learn any topic they're interested in. Be concise, friendly, and encouraging.
When asked to "Start Lesson", suggest a learning path. When asked to "Explain Topic", ask what topic to explain.
When asked to "Generate Quiz", create a short 3-question quiz on a topic of the user's choice.`;

const quickActions = [
  { icon: BookOpen, label: 'Start Lesson', color: '#06B6D4' },
  { icon: HelpCircle, label: 'Explain Topic', color: '#06B6D4' },
  { icon: FileQuestion, label: 'Generate Quiz', color: '#06B6D4' },
];

type Message = { type: 'ai' | 'user'; text: string };

const initialMessages: Message[] = [
  { type: 'ai', text: "Hi! I'm your AI tutor. I'm here to help you learn anything you'd like. What would you like to explore today?" },
];

async function fetchGroqResponse(history: Message[]): Promise<string> {
  const groqMessages = history.map((m) => ({
    role: m.type === 'user' ? 'user' : 'assistant',
    content: m.text,
  }));

  const res = await fetch(GROQ_API_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${GROQ_API_KEY}`,
    },
    body: JSON.stringify({
      model: 'llama-3.3-70b-versatile',
      messages: [{ role: 'system', content: SYSTEM_PROMPT }, ...groqMessages],
      max_tokens: 512,
    }),
  });

  if (!res.ok) throw new Error(`Groq error: ${res.status}`);
  const data = await res.json();
  return data.choices[0].message.content as string;
}

export default function AITutor() {
  const navigate = useNavigate();
  const [messages, setMessages] = useState<Message[]>(initialMessages);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const bottomRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages, loading]);

  const sendMessage = async (text: string) => {
    const updated: Message[] = [...messages, { type: 'user', text }];
    setMessages(updated);
    setInput('');
    setLoading(true);
    try {
      const reply = await fetchGroqResponse(updated);
      setMessages((prev) => [...prev, { type: 'ai', text: reply }]);
    } catch {
      setMessages((prev) => [...prev, { type: 'ai', text: 'Sorry, something went wrong. Please try again.' }]);
    } finally {
      setLoading(false);
    }
  };

  const handleSend = () => { if (input.trim() && !loading) sendMessage(input.trim()); };
  const handleQuickAction = (label: string) => { if (!loading) sendMessage(label); };

  return (
    <div className="min-h-screen bg-gradient-to-b from-[#06B6D4]/5 to-white pb-20">
      <div className="max-w-md mx-auto flex flex-col h-screen">
        {/* Header */}
        <div className="bg-gradient-to-r from-[#06B6D4] to-[#0891B2] px-6 pt-12 pb-6 rounded-b-3xl shadow-lg flex-shrink-0">
          <div className="flex items-center gap-4 mb-4">
            <button
              onClick={() => navigate('/home')}
              className="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center hover:bg-white/30 transition-colors"
            >
              <ArrowLeft className="w-5 h-5 text-white" />
            </button>
            <div className="flex-1">
              <h1 className="text-white text-2xl">AI Tutor</h1>
              <div className="flex items-center gap-2 mt-1">
                <div className="w-2 h-2 rounded-full bg-green-400 animate-pulse"></div>
                <span className="text-white/90 text-sm">Always available</span>
              </div>
            </div>
            <div className="w-12 h-12 rounded-full bg-white/20 flex items-center justify-center">
              <Sparkles className="w-7 h-7 text-white" />
            </div>
          </div>
        </div>

        {/* Quick Actions */}
        <div className="px-6 py-4 flex-shrink-0">
          <div className="flex gap-3 overflow-x-auto pb-2">
            {quickActions.map((action, index) => (
              <button
                key={index}
                onClick={() => handleQuickAction(action.label)}
                className="flex-shrink-0 px-4 py-3 rounded-xl bg-white border-2 border-[#06B6D4]/20 hover:border-[#06B6D4] hover:bg-[#06B6D4]/5 transition-all flex items-center gap-2 shadow-sm"
              >
                <action.icon className="w-5 h-5" style={{ color: action.color }} />
                <span className="text-sm text-gray-700 whitespace-nowrap">{action.label}</span>
              </button>
            ))}
          </div>
        </div>

        {/* Messages */}
        <div className="flex-1 overflow-y-auto px-6 py-4 space-y-4">
          {messages.map((message, index) => (
            <div
              key={index}
              className={`flex ${message.type === 'user' ? 'justify-end' : 'justify-start'}`}
            >
              <div
                className={`max-w-[80%] rounded-2xl px-4 py-3 ${
                  message.type === 'user'
                    ? 'bg-[#4F46E5] text-white rounded-br-sm'
                    : 'bg-white text-gray-800 rounded-bl-sm shadow-sm border border-[#06B6D4]/10'
                }`}
              >
                {message.type === 'ai' && (
                  <div className="flex items-center gap-2 mb-1">
                    <Sparkles className="w-4 h-4 text-[#06B6D4]" />
                    <span className="text-xs text-[#06B6D4]">AI Tutor</span>
                  </div>
                )}
                <p className="text-sm leading-relaxed">{message.text}</p>
              </div>
            </div>
          ))}

          {loading && (
            <div className="flex justify-start">
              <div className="bg-white rounded-2xl rounded-bl-sm px-4 py-3 shadow-sm border border-[#06B6D4]/10">
                <div className="flex items-center gap-2 mb-1">
                  <Sparkles className="w-4 h-4 text-[#06B6D4]" />
                  <span className="text-xs text-[#06B6D4]">AI Tutor</span>
                </div>
                <div className="flex gap-1 items-center h-5">
                  <span className="w-2 h-2 rounded-full bg-[#06B6D4] animate-bounce" style={{ animationDelay: '0ms' }} />
                  <span className="w-2 h-2 rounded-full bg-[#06B6D4] animate-bounce" style={{ animationDelay: '150ms' }} />
                  <span className="w-2 h-2 rounded-full bg-[#06B6D4] animate-bounce" style={{ animationDelay: '300ms' }} />
                </div>
              </div>
            </div>
          )}

          {messages.length === 1 && !loading && (
            <div className="text-center py-8">
              <div className="inline-flex items-center justify-center w-20 h-20 rounded-full bg-gradient-to-br from-[#06B6D4]/20 to-[#0891B2]/20 mb-4">
                <Sparkles className="w-10 h-10 text-[#06B6D4]" />
              </div>
              <h3 className="text-gray-900 mb-2">Start Learning</h3>
              <p className="text-gray-600 text-sm px-8">
                Ask me anything or choose a quick action above to get started!
              </p>
            </div>
          )}

          <div ref={bottomRef} />
        </div>

        {/* Input Area */}
        <div className="px-6 py-4 bg-white border-t border-gray-200 flex-shrink-0">
          <div className="flex items-center gap-3">
            <input
              type="text"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyPress={(e) => e.key === 'Enter' && handleSend()}
              placeholder="Ask anything..."
              className="flex-1 px-4 py-3 bg-gray-100 rounded-2xl focus:outline-none focus:ring-2 focus:ring-[#06B6D4]/20"
            />
            <button
              onClick={handleSend}
              disabled={!input.trim() || loading}
              className="w-12 h-12 rounded-full bg-gradient-to-br from-[#06B6D4] to-[#0891B2] flex items-center justify-center hover:shadow-lg transition-all disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <Send className="w-5 h-5 text-white" />
            </button>
          </div>
        </div>
      </div>

      <BottomNav />
    </div>
  );
}
