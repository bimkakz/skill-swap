import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 24),
                  const Text('Choose Your Learning Path', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildPathCard(
                    title: 'Exchange Skills',
                    description: 'Trade knowledge with peers. Learn guitar, teach coding!',
                    icon: Icons.repeat,
                    gradient: const [SkillSwapColors.primary, Color(0xFF6366F1)],
                    onTap: () => Navigator.pushNamed(context, '/skill-exchange'),
                  ),
                  const SizedBox(height: 12),
                  _buildPathCard(
                    title: 'Find a Teacher',
                    description: 'Book professional lessons with verified experts',
                    icon: Icons.school,
                    gradient: const [SkillSwapColors.secondary, Color(0xFF16A34A)],
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildPathCard(
                    title: 'AI Tutor',
                    description: 'Learn anything, anytime with your AI assistant',
                    icon: Icons.auto_awesome,
                    gradient: const [SkillSwapColors.accent, Color(0xFF0891B2)],
                    onTap: () => Navigator.pushNamed(context, '/ai-tutor'),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recommended for You', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(onPressed: () {}, child: const Text('See all', style: TextStyle(color: SkillSwapColors.primary))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRecommendationItem(
                    name: 'Sarah Chen',
                    skill: 'Japanese Language',
                    rating: 4.9,
                    type: 'exchange',
                    points: 50,
                    imageUrl: 'https://images.unsplash.com/photo-1581065178047-8ee15951ede6?q=80&w=200',
                  ),
                  _buildRecommendationItem(
                    name: 'Alex Morgan',
                    skill: 'Guitar & Music',
                    rating: 4.8,
                    type: 'paid',
                    price: '\$25/hr',
                    imageUrl: 'https://images.unsplash.com/photo-1680721698104-5fff20073eee?q=80&w=200',
                  ),
                  const SizedBox(height: 100), // BottomNav spacing
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Hello, Alex 👋', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('What would you like to learn today?', style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
              _buildPointsBadge(1250),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search skills or teachers...',
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

  Widget _buildPointsBadge(int points) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.amber, Colors.orange]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          const Icon(Icons.stars, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(points.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPathCard({required String title, required String description, required IconData icon, required List<Color> gradient, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: gradient[0].withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: Colors.white, size: 24),
                      const SizedBox(width: 8),
                      Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(description, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                ],
              ),
            ),
            Icon(Icons.trending_up, color: Colors.white.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem({required String name, required String skill, required double rating, required String type, int? points, String? price, required String imageUrl}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(imageUrl), radius: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(skill, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(' $rating', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    if (type == 'exchange') Text('• $points pts', style: const TextStyle(fontSize: 12, color: Colors.amber, fontWeight: FontWeight.bold)),
                    if (type == 'paid') Text('• $price', style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(80, 40),
              backgroundColor: type == 'paid' ? SkillSwapColors.secondary : SkillSwapColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(type == 'paid' ? 'Book' : 'Connect', style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }


}
