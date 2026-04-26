import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart'; // Import themeNotifier
import 'history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Not logged in')));
    }

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context, user, userData),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      _buildPointsSection(userData, context),
                      const SizedBox(height: 24),
                      _buildSkillsSection(userData, context),
                      const SizedBox(height: 24),
                      _buildMenuSection(context, userData),
                      const SizedBox(height: 100), // BottomNav spacing
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, User user, Map<String, dynamic> userData) {
    final userName = userData['name']?.toString() ?? user.displayName ?? 'User';
    final userEmail = user.email ?? 'No email';
    final initials = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

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
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: themeNotifier,
                    builder: (_, mode, __) {
                      return IconButton(
                        icon: Icon(mode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode, color: Colors.white),
                        onPressed: () {
                          themeNotifier.value = mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
                        },
                      );
                    },
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(Icons.settings, color: Colors.white),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Text(initials, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: SkillSwapColors.primary)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(userName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(width: 8),
                const Icon(Icons.verified, color: Colors.blueAccent, size: 24),
              ],
            ),
            Text(userEmail, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 4),
            const Text('Member since joining', style: TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 24),
            _buildStatsBar(userData, context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsBar(Map<String, dynamic> userData, BuildContext context) {
    final exchanges = (userData['exchanges'] ?? 0).toString();
    final lessons = userData['lessons']?.toString() ?? '0';
    final rating = double.tryParse(userData['rating']?.toString() ?? '0.0')?.toStringAsFixed(1) ?? '0.0';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: isDark ? Colors.black26 : Colors.black12, blurRadius: 10, offset: const Offset(0, 5))],
        border: Border.all(color: isDark ? Colors.white10 : Colors.transparent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Exchanges', exchanges, Icons.repeat, SkillSwapColors.primary, context),
          _buildStatItem('Lessons', lessons, Icons.school, SkillSwapColors.secondary, context),
          _buildStatItem('Rating', rating, Icons.star, Colors.amber, context),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color, BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color)),
      ],
    );
  }

  Widget _buildPointsSection(Map<String, dynamic> userData, BuildContext context) {
    final points = userData['points']?.toString() ?? '0';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
            ? [Colors.amber.withOpacity(0.1), Colors.orange.withOpacity(0.05)]
            : [const Color(0xFFFFF8E1), const Color(0xFFFFF3E0)]
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.amber.withOpacity(isDark ? 0.3 : 1.0)),
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
                child: Text(points, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(Map<String, dynamic> userData, BuildContext context) {
    final teachingSkills = (userData['teaching_skills'] as List<dynamic>?)?.map((e)=>e.toString()).toList() ?? [];
    final learningSkills = (userData['learning_skills'] as List<dynamic>?)?.map((e)=>e.toString()).toList() ?? [];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, 
        borderRadius: BorderRadius.circular(24), 
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('My Skills', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: () => _showAddSkillDialog(context, 'Teaching'),
                icon: Icon(Icons.add_circle, color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (teachingSkills.isEmpty && learningSkills.isEmpty)
            const Text('No skills added yet.', style: TextStyle(color: Colors.grey)),
          if (teachingSkills.isNotEmpty)
            _buildSkillRow('Teaching', teachingSkills, Colors.green, context),
          if (teachingSkills.isNotEmpty && learningSkills.isNotEmpty) const SizedBox(height: 16),
          if (learningSkills.isNotEmpty)
            _buildSkillRow('Learning', learningSkills, Colors.blue, context),
        ],
      ),
    );
  }

  void _showAddSkillDialog(BuildContext context, String type) {
    final TextEditingController controller = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Add $type Skill'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'E.g. Spanish, React, Piano...',
              filled: true,
              fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.trim().isEmpty) return;
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  final field = type == 'Teaching' ? 'teaching_skills' : 'learning_skills';
                  await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                    field: FieldValue.arrayUnion([controller.text.trim()]),
                  });
                }
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(80, 40)),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSkillRow(String label, List<String> skills, Color color, BuildContext context) {
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
            GestureDetector(
              onTap: () => _showAddSkillDialog(context, label),
              child: CircleAvatar(radius: 14, backgroundColor: Theme.of(context).dividerColor, child: const Icon(Icons.add, size: 16, color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context, Map<String, dynamic> userData) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, 
        borderRadius: BorderRadius.circular(24), 
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          _buildMenuItem(Icons.edit, 'Edit Profile', onTap: () => _editProfile(context, userData), context: context),
          _buildMenuItem(Icons.repeat, 'My Exchanges', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen(type: 'exchange'))), context: context),
          _buildMenuItem(Icons.school, 'My Lessons', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen(type: 'lesson'))), context: context),
          _buildMenuItem(Icons.logout, 'Log Out', isLast: true, color: Colors.red, onTap: () async {
            await FirebaseAuth.instance.signOut();
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            }
          }, context: context),
        ],
      ),
    );
  }

  void _editProfile(BuildContext context, Map<String, dynamic> userData) {
    final TextEditingController nameCtl = TextEditingController(text: userData['name']?.toString() ?? '');
    final TextEditingController bioCtl = TextEditingController(text: userData['bio']?.toString() ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtl, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 12),
            TextField(controller: bioCtl, decoration: const InputDecoration(labelText: 'Bio (Short)'), maxLines: 2),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                  'name': nameCtl.text.trim(),
                  'bio': bioCtl.text.trim(),
                });
                await user.updateDisplayName(nameCtl.text.trim());
              }
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(80, 40)),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, {bool isLast = false, Color? color, VoidCallback? onTap, required BuildContext context}) {
    final Color effectiveColor = color ?? Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    return ListTile(
      onTap: onTap,
      leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey.shade100, shape: BoxShape.circle), child: Icon(icon, color: effectiveColor, size: 20)),
      title: Text(label, style: TextStyle(color: effectiveColor, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right, size: 20, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5)),
      shape: isLast ? null : Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
    );
  }
}
