import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  _buildPointsSection(),
                  const SizedBox(height: 24),
                  _buildSkillsSection(),
                  const SizedBox(height: 24),
                  _buildMenuSection(context),
                  const SizedBox(height: 100), // BottomNav spacing
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [SkillSwapColors.primary, Color(0xFF6366F1)]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(Icons.settings, color: Colors.white),
                  ),
                ],
              ),
            ),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Text('AJ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: SkillSwapColors.primary)),
            ),
            const SizedBox(height: 16),
            const Text('Alex Johnson', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const Text('alex.johnson@email.com', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 4),
            const Text('Member since February 2026', style: TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 24),
            _buildStatsBar(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Exchanges', '12', Icons.repeat, SkillSwapColors.primary),
          _buildStatItem('Lessons', '8', Icons.school, SkillSwapColors.secondary),
          _buildStatItem('Rating', '4.9', Icons.star, Colors.amber),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildPointsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFFF8E1), Color(0xFFFFF3E0)]),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.stars, color: Colors.amber),
                  SizedBox(width: 8),
                  Text('SkillSwap Points', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(16)),
                child: const Text('1,250', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Earn points by teaching skills and spend them to learn from others', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Skills', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('Edit', style: TextStyle(color: SkillSwapColors.primary, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          _buildSkillRow('Teaching', ['Web Dev', 'React', 'UI/UX'], Colors.green),
          const SizedBox(height: 16),
          _buildSkillRow('Learning', ['Spanish', 'Guitar'], Colors.blue),
        ],
      ),
    );
  }

  Widget _buildSkillRow(String label, List<String> skills, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...skills.map((s) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text(s, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
            )),
            const CircleAvatar(radius: 14, backgroundColor: Colors.black12, child: Icon(Icons.add, size: 16, color: Colors.white)),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]),
      child: Column(
        children: [
          _buildMenuItem(Icons.edit, 'Edit Profile'),
          _buildMenuItem(Icons.repeat, 'My Exchanges'),
          _buildMenuItem(Icons.school, 'My Lessons'),
          _buildMenuItem(Icons.logout, 'Log Out', isLast: true, color: Colors.red, onTap: () async {
            await FirebaseAuth.instance.signOut();
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            }
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, {bool isLast = false, Color color = SkillSwapColors.textHeader, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle), child: Icon(icon, color: color, size: 20)),
      title: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      shape: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.shade100)),
    );
  }


}
