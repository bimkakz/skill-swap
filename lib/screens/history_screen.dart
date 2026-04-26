import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../theme.dart';
import 'chat_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  final String type; // 'exchange' or 'lesson'

  const HistoryScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Not logged in')));
    }

    final title = type == 'exchange' ? 'My Exchanges' : 'My Lessons';
    final icon = type == 'exchange' ? Icons.repeat : Icons.school;
    final color = type == 'exchange' ? SkillSwapColors.primary : SkillSwapColors.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.8)],
            ),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('history')
            .where('type', isEqualTo: type)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading history.'));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 64, color: Colors.grey.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text('No ${type}s yet.', style: const TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text('Go back and start connecting!', style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return _buildHistoryCard(context, data, type);
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, Map<String, dynamic> data, String type) {
    final partnerName = data['partnerName']?.toString() ?? 'Unknown User';
    final partnerId = data['partnerId']?.toString() ?? '';
    final pointsAwarded = data['pointsAwarded'] as int?;
    
    DateTime date = DateTime.now();
    if (data['timestamp'] != null) {
      date = (data['timestamp'] as Timestamp).toDate();
    }
    final formattedDate = DateFormat('MMM d, yyyy • h:mm a').format(date);
    final initials = partnerName.isNotEmpty ? partnerName[0].toUpperCase() : 'U';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Text(initials, style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
        ),
        title: Text(
          partnerName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(formattedDate, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6))),
            if (pointsAwarded != null && type == 'exchange')
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.stars, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text('+$pointsAwarded Points', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.chat_bubble_outline),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            if (partnerId.isNotEmpty) {
               Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetailScreen(
                  receiverId: partnerId,
                  receiverName: partnerName,
                  isExchangeMode: type == 'exchange',
               )));
            }
          },
        ),
      ),
    );
  }
}
