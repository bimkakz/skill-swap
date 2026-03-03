import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/ai_tutor_screen.dart';
import 'screens/skill_exchange_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/chat_detail_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const SkillSwapApp());
}

class SkillSwapApp extends StatelessWidget {
  const SkillSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillSwap',
      debugShowCheckedModeBanner: false,
      theme: SkillSwapTheme.light,
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/ai-tutor': (context) => const AITutorScreen(),
        '/skill-exchange': (context) => const SkillExchangeScreen(),
        '/explore': (context) => const ExploreScreen(),
        '/messages': (context) => const MessagesScreen(),
        '/chat-detail': (context) => const ChatDetailScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
