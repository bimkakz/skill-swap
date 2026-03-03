import 'package:flutter/material.dart';
import '../theme.dart';

class SkillExchangeScreen extends StatelessWidget {
  const SkillExchangeScreen({super.key});

  final List<Map<String, dynamic>> _users = const [
    {
      'name': 'Maria Garcia',
      'image': 'https://images.unsplash.com/photo-1770564512654-35be546ed257?q=80&w=200',
      'offering': ['Spanish', 'Photography'],
      'wanting': ['Web Development', 'Guitar'],
      'rating': 4.9,
      'pts': 100,
      'bio': 'Native Spanish speaker and hobby photographer. Love to meet new people!'
    },
    {
      'name': 'David Kim',
      'image': 'https://images.unsplash.com/photo-1764816657425-b3c79b616d14?q=80&w=200',
      'offering': ['Korean', 'Piano'],
      'wanting': ['French', 'Cooking'],
      'rating': 5.0,
      'pts': 150,
      'bio': 'Math teacher by day, musician by night. Always happy to help!'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Exchange', style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [SkillSwapColors.primary, Color(0xFF6366F1)]),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: const Border(left: BorderSide(color: SkillSwapColors.primary, width: 4)),
              boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: const Text(
              'How it works: Connect with others and exchange skills. You teach something, they teach you something in return!',
              style: TextStyle(fontSize: 14, color: SkillSwapColors.textBody),
            ),
          ),
          const SizedBox(height: 24),
          ..._users.map((user) => _buildUserCard(user, context)),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(backgroundImage: NetworkImage(user['image']), radius: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(' ${user['rating']}'),
                          const Spacer(),
                          const Icon(Icons.stars, color: Colors.amber, size: 16),
                          Text(' ${user['pts']} pts/hr', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(user['bio'], style: TextStyle(color: Colors.grey.shade600, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSkillTagList('Offering', user['offering'], Colors.green),
                const SizedBox(height: 12),
                _buildSkillTagList('Looking for', user['wanting'], Colors.blue),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24))),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Message'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.repeat),
                    label: const Text('Exchange'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillTagList(String label, List<String> skills, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: skills.map((s) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.2))),
            child: Text(s, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
          )).toList(),
        ),
      ],
    );
  }
}
