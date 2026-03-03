import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/bottom_nav_bar.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  final List<Map<String, dynamic>> conversations = const [
    {
      'name': 'Maria Garcia',
      'image': 'https://images.unsplash.com/photo-1770564512654-35be546ed257?q=80&w=200',
      'lastMessage': "Great! Let's start next week then.",
      'time': '2m ago',
      'unread': 2,
      'online': true,
    },
    {
      'name': 'David Kim',
      'image': 'https://images.unsplash.com/photo-1764816657425-b3c79b616d14?q=80&w=200',
      'lastMessage': 'Thanks for the piano lesson!',
      'time': '1h ago',
      'unread': 0,
      'online': false,
    },
    {
      'name': 'Sophie Laurent',
      'image': 'https://images.unsplash.com/photo-1623594675959-02360202d4d6?q=80&w=200',
      'lastMessage': 'Can we reschedule to tomorrow?',
      'time': '3h ago',
      'unread': 1,
      'online': true,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  return _buildConversationItem(conversations[index], context);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Messages', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search conversations...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationItem(Map<String, dynamic> convo, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/chat-detail'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(convo['image']), radius: 28),
                if (convo['online'])
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(convo['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(convo['time'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(convo['lastMessage'], style: TextStyle(color: Colors.grey.shade600, fontSize: 14), overflow: TextOverflow.ellipsis)),
                      if (convo['unread'] > 0)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: SkillSwapColors.primary, shape: BoxShape.circle),
                          child: Text(convo['unread'].toString(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
