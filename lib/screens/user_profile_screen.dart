import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme.dart';
import 'chat_detail_screen.dart';
import 'package:intl/intl.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> userData;

  const UserProfileScreen({super.key, required this.userId, required this.userData});

  @override
  Widget build(BuildContext context) {
    final name = userData['name']?.toString() ?? 'User';
    final bio = userData['bio']?.toString() ?? 'No bio yet.';
    final rating = double.tryParse(userData['rating']?.toString() ?? '0.0')?.toStringAsFixed(1) ?? '0.0';
    final points = userData['points']?.toString() ?? '0';
    final exchanges = userData['exchanges']?.toString() ?? '0';
    final lessons = userData['lessons']?.toString() ?? '0';
    final initials = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    
    final teachingSkills = (userData['teaching_skills'] as List<dynamic>?)?.map((e)=>e.toString()).toList() ?? [];
    final learningSkills = (userData['learning_skills'] as List<dynamic>?)?.map((e)=>e.toString()).toList() ?? [];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [SkillSwapColors.primary, Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(initials, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: SkillSwapColors.primary)),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 18),
                              Text(' $rating Rating', style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 12),
                              const Icon(Icons.stars, color: Colors.amber, size: 18),
                              Text(' $points Pts', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(bio, style: TextStyle(fontSize: 15, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8), height: 1.5)),
                  const SizedBox(height: 32),
                  _buildStatsRow(context, exchanges, lessons),
                  const SizedBox(height: 32),
                  if (teachingSkills.isNotEmpty) ...[
                    const Text('Can Teach', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: teachingSkills.map((s) => _buildSkillChip(s, Colors.green)).toList(),
                    ),
                    const SizedBox(height: 24),
                  if (learningSkills.isNotEmpty) ...[
                    const Text('Wants to Learn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: learningSkills.map((s) => _buildSkillChip(s, Colors.blue)).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  const SizedBox(height: 16),
                  const Text('Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildReviewsSection(context),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetailScreen(
                              receiverId: userId,
                              receiverName: name,
                              isExchangeMode: true,
                            )));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: SkillSwapColors.primary,
                          ),
                          child: const Text('Connect for Exchange', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetailScreen(
                              receiverId: userId,
                              receiverName: name,
                              isExchangeMode: false,
                            )));
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: SkillSwapColors.secondary),
                          ),
                          child: const Text('Book a Lesson', style: TextStyle(color: SkillSwapColors.secondary, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, String exchanges, String lessons) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat(exchanges, 'Exchanges', Icons.repeat, SkillSwapColors.primary),
          Container(height: 30, width: 1, color: Theme.of(context).dividerColor),
          _buildStat(lessons, 'Lessons', Icons.school, SkillSwapColors.secondary),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSkillChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
    );
  Widget _buildReviewsSection(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(userId).collection('reviews').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('No reviews yet.', style: TextStyle(color: Colors.grey)),
          );
        }

        return Column(
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final author = data['authorName'] ?? 'Anonymous';
            final text = data['text'] ?? '';
            final rating = (data['rating'] ?? 0.0).toDouble();
            final ts = data['timestamp'] as Timestamp?;
            final date = ts != null ? DateFormat('MMM d, yyyy').format(ts.toDate()) : '';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(author, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(5, (index) => Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      size: 14,
                      color: Colors.amber,
                    )),
                  ),
                  const SizedBox(height: 8),
                  Text(text, style: const TextStyle(fontSize: 14)),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
