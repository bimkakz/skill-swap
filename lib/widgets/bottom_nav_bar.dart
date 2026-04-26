import 'package:flutter/material.dart';
import '../theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;
  const BottomNavBar({super.key, required this.currentIndex, this.onTap});

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
          _buildNavItem(context, Icons.home, 'Home', currentIndex == 0, 0),
          _buildNavItem(context, Icons.explore, 'Explore', currentIndex == 1, 1),
          _buildNavItem(context, Icons.auto_awesome, 'AI Tutor', currentIndex == 2, 2),
          _buildNavItem(context, Icons.person, 'Profile', currentIndex == 3, 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool active, int index) {
    return GestureDetector(
      onTap: () {
        if (!active && onTap != null) {
          onTap!(index);
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
