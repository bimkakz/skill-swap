import 'package:flutter/material.dart';
import '../theme.dart';

class AITutorScreen extends StatefulWidget {
  const AITutorScreen({super.key});

  @override
  State<AITutorScreen> createState() => _AITutorScreenState();
}

class _AITutorScreenState extends State<AITutorScreen> {
  final List<Map<String, String>> _messages = [
    {
      'type': 'ai',
      'text':
          "Hi! I'm your AI tutor. I'm here to help you learn anything you'd like. What would you like to explore today?"
    }
  ];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Spanish', 'Russian', 'French'];

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    final userText = _controller.text.trim();
    
    setState(() {
      _messages.add({'type': 'user', 'text': userText});
      _controller.clear();
      _isTyping = true;
    });
    _scrollToBottom();

    // AI logic simulation
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      
      String aiResponse = '';
      final lowerText = userText.toLowerCase();

      if (lowerText.contains('hello') || lowerText.contains('hi') || lowerText.contains('привет')) {
        if (_selectedLanguage == 'Russian') {
          aiResponse = "Добро пожаловать на урок! Я ваш ИИ-Репетитор. Какую тему мы сегодня изучаем?";
        } else if (_selectedLanguage == 'Spanish') {
          aiResponse = "¡Bienvenido a clase! Soy tu tutor de IA. ¿Qué tema vamos a estudiar hoy?";
        } else {
          aiResponse = "Welcome to class! I am your AI Tutor. Let's make learning interactive. What subject are we diving into today?";
        }
      } else if (lowerText.contains('dart') || lowerText.contains('flutter')) {
        aiResponse = "Ah, Flutter! It's fantastic for cross-platform apps. But as a teacher, I won't just give you the code. Tell me, what do you think is the main difference between a StatelessWidget and a StatefulWidget?";
      } else if (lowerText.contains('math') || lowerText.contains('equation') || lowerText.contains('математика')) {
        aiResponse = "Mathematics! Let's work through it step-by-step. Instead of me giving you the answer, what is the first operation you think we should perform based on the order of operations (PEMDAS)?";
      } else if (lowerText.contains('language') || lowerText.contains('spanish') || lowerText.contains('english') || lowerText.contains('язык')) {
        aiResponse = "¡Excelente! The best way to learn a language is practice. Let's do a quick drill. How would you translate: 'I want to learn' into your target language?";
      } else if (lowerText.contains('lesson') || lowerText.contains('teach') || lowerText.contains('урок')) {
        aiResponse = "I'd love to organize a lesson for you. Let's start with a diagnostic question to gauge your level. What is a concept in this field you are already comfortable with?";
      } else if (lowerText.contains('how to') || lowerText.contains('explain') || lowerText.contains('как')) {
        aiResponse = "Good question. Let's break it down together. I'll give you a hint: think about the fundamental concepts. What part of it specifically confuses you?";
      } else {
        if (_selectedLanguage == 'Russian') {
          aiResponse = "Интересная мысль! Как ваш репетитор, я предлагаю вам подумать еще на шаг вперед. Как это связано с тем, что мы учили ранее?";
        } else {
          aiResponse = "That's an interesting thought! As your tutor, I challenge you to think a step further. How does that connect to what we learned previously, or what real-world application does it have?";
        }
      }

      setState(() {
        _isTyping = false;
        _messages.add({'type': 'ai', 'text': aiResponse});
      });
      _scrollToBottom();
    });
  }

  void _sendQuickAction(String action) {
    _controller.text = action;
    _sendMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Tutor', style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [SkillSwapColors.accent, Color(0xFF0891B2)]),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              child: const Icon(Icons.auto_awesome, color: Colors.white),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickAction('Start Lesson', Icons.book),
                  _buildQuickAction('Explain Flutter', Icons.help_outline),
                  _buildQuickAction('How to learn Spanish', Icons.language),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                   return Align(
                     alignment: Alignment.centerLeft,
                     child: Container(
                       margin: const EdgeInsets.only(bottom: 12),
                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                       child: Row(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                            SizedBox(
                              width: 12, height: 12,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Theme.of(context).primaryColor),
                            ),
                            const SizedBox(width: 8),
                            Text("AI is thinking...", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12)),
                         ],
                       ),
                     ),
                   );
                }

                final msg = _messages[index];
                final isUser = msg['type'] == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isUser ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isUser ? 20 : 0),
                        bottomRight: Radius.circular(isUser ? 0 : 20),
                      ),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isUser)
                          const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome,
                                  size: 12, color: SkillSwapColors.accent),
                              SizedBox(width: 4),
                              Text('AI Tutor',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: SkillSwapColors.accent,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        Text(
                          msg['text']!,
                          style: TextStyle(
                              color: isUser
                                  ? Colors.white
                                  : Theme.of(context).textTheme.bodyLarge?.color,
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask anything...',
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [SkillSwapColors.accent, Color(0xFF0891B2)]),
                    ),
                    child:
                        const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: ActionChip(
        avatar: Icon(icon, color: Theme.of(context).primaryColor, size: 18),
        label: Text(label),
        backgroundColor: Theme.of(context).cardColor,
        side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.2)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onPressed: () => _sendQuickAction(label),
      ),
    );
  }
}
