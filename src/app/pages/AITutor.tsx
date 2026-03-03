import { useState } from 'react';
import { Send, Sparkles, BookOpen, HelpCircle, FileQuestion, ArrowLeft } from 'lucide-react';
import { useNavigate } from 'react-router';
import { BottomNav } from '../components/BottomNav';

const quickActions = [
  { icon: BookOpen, label: 'Start Lesson', color: '#06B6D4' },
  { icon: HelpCircle, label: 'Explain Topic', color: '#06B6D4' },
  { icon: FileQuestion, label: 'Generate Quiz', color: '#06B6D4' },
];

const sampleMessages = [
  { type: 'ai', text: "Hi! I'm your AI tutor. I'm here to help you learn anything you'd like. What would you like to explore today?" },
];

export default function AITutor() {
  const navigate = useNavigate();
  const [messages, setMessages] = useState(sampleMessages);
  const [input, setInput] = useState('');

  const handleSend = () => {
    if (input.trim()) {
      setMessages([...messages, { type: 'user', text: input }]);
      setInput('');
      
      // Simulate AI response
      setTimeout(() => {
        setMessages((prev) => [
          ...prev,
          {
            type: 'ai',
            text: "That's a great question! Let me help you understand that better. I can create a personalized lesson plan for you.",
          },
        ]);
      }, 1000);
    }
  };

  const handleQuickAction = (label: string) => {
    setMessages([...messages, { type: 'user', text: label }]);
    
    setTimeout(() => {
      setMessages((prev) => [
        ...prev,
        {
          type: 'ai',
          text: `I'd be happy to help with "${label}". What topic would you like to focus on?`,
        },
      ]);
    }, 1000);
  };

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

          {messages.length === 1 && (
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
              disabled={!input.trim()}
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
