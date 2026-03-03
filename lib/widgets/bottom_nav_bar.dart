import 'package:flutter/material.dart';
import '../theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.home, 'Home', currentIndex == 0, '/home'),
          _buildNavItem(context, Icons.explore, 'Explore', currentIndex == 1, '/explore'),
          _buildNavItem(context, Icons.chat_bubble, 'Messages', currentIndex == 2, '/messages'),
          _buildNavItem(context, Icons.person, 'Profile', currentIndex == 3, '/profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool active, String route) {
    return GestureDetector(
      onTap: () {
        if (!active) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: active ? SkillSwapColors.primary : Colors.grey, size: 28),
          Text(label, style: TextStyle(color: active ? SkillSwapColors.primary : Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
