import 'package:flutter/material.dart';
import '../theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_detail_screen.dart';

class SkillExchangeScreen extends StatelessWidget {
  const SkillExchangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Skill Exchange', style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [SkillSwapColors.primary, Color(0xFF6366F1)]),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final currentUserId = FirebaseAuth.instance.currentUser?.uid;
          
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(currentUserId).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
              
              final myData = userSnapshot.data?.data() as Map<String, dynamic>? ?? {};
              final myLearning = (myData['learning_skills'] as List<dynamic>?)?.map((e)=>e.toString().toLowerCase()).toList() ?? [];
              final myTeaching = (myData['teaching_skills'] as List<dynamic>?)?.map((e)=>e.toString().toLowerCase()).toList() ?? [];
              
              final users = snapshot.data!.docs.where((d) {
                if (d.id == currentUserId) return false;
                final data = d.data() as Map<String, dynamic>;
                final theirTeaching = (data['teaching_skills'] as List<dynamic>?)?.map((e)=>e.toString().toLowerCase()).toList() ?? [];
                final theirLearning = (data['learning_skills'] as List<dynamic>?)?.map((e)=>e.toString().toLowerCase()).toList() ?? [];
                
                // Smart Match: Only show users if they teach what I want to learn, OR they want to learn what I teach
                final match = myLearning.any((s) => theirTeaching.contains(s)) || myTeaching.any((s) => theirLearning.contains(s));
                
                // Fallback: If current user hasn't set any skills, show everyone so it's not empty
                return match || (myLearning.isEmpty && myTeaching.isEmpty);
              }).toList();

              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border(
                      left: BorderSide(color: Theme.of(context).primaryColor, width: 4)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))
                  ],
                ),
                child: Text(
                  'How it works: Connect with others and exchange skills. You teach something, they teach you something in return!',
                  style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
              ),
              const SizedBox(height: 24),
              if (users.isEmpty)
                const Center(child: Text('No other users found right now.', style: TextStyle(color: Colors.grey))),
              ...users.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return _buildUserCard(doc.id, data, context);
              }),
            ],
          );
            }
          );
        }
      ),
    );
  }

  Widget _buildUserCard(String userId, Map<String, dynamic> user, BuildContext context) {
    final name = user['name']?.toString() ?? 'User';
    final rating = user['rating']?.toString() ?? '0.0';
    final points = user['points']?.toString() ?? '0';
    final bio = user['bio']?.toString() ?? 'Enthusiastic learner looking to exchange skills.';
    final initials = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    final List<String> offering = (user['teaching_skills'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    final List<String> wanting = (user['learning_skills'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: SkillSwapColors.primary.withOpacity(0.2),
                  radius: 32,
                  child: Text(initials, style: const TextStyle(fontSize: 24, color: SkillSwapColors.primary, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, color: Colors.blue, size: 16),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(' $rating'),
                          const Spacer(),
                          const Icon(Icons.stars,
                              color: Colors.amber, size: 16),
                          Text(' $points pts',
                              style: const TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(bio,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
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
                if (offering.isNotEmpty)
                  _buildSkillTagList('Offering', offering, Colors.green),
                if (offering.isNotEmpty) const SizedBox(height: 12),
                if (wanting.isNotEmpty)
                  _buildSkillTagList('Looking for', wanting, Colors.blue),
                if (wanting.isNotEmpty || offering.isNotEmpty) const SizedBox(height: 20),
                if (wanting.isEmpty && offering.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text('No specific skills listed yet.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(24))),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetailScreen(
                        receiverId: userId,
                        receiverName: name,
                      )));
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Message'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.star_outline),
                  label: const Text('Review'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(color: Colors.amber.shade300),
                    foregroundColor: Colors.amber.shade700,
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
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
            Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: skills
              .map((s) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: color.withOpacity(0.2))),
                    child: Text(s,
                        style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
