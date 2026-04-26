import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/bottom_nav_bar.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String searchQuery = "";
  
  final List<Map<String, dynamic>> categories = const [
    {
      'name': 'Languages',
      'icon': '🌍',
      'color': Color(0xFF4F46E5),
      'count': 124
    },
    {'name': 'Music', 'icon': '🎵', 'color': Color(0xFF22C55E), 'count': 98},
    {
      'name': 'Technology',
      'icon': '💻',
      'color': Color(0xFF06B6D4),
      'count': 156
    },
    {
      'name': 'Arts & Crafts',
      'icon': '🎨',
      'color': Color(0xFFEAB308),
      'count': 87
    },
    {'name': 'Fitness', 'icon': '💪', 'color': Color(0xFFEF4444), 'count': 65},
    {'name': 'Cooking', 'icon': '🍳', 'color': Color(0xFFF59E0B), 'count': 72},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredCategories = categories.where((c) => 
      c['name'].toString().toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 24),
                  const Text('Categories',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  if (filteredCategories.isEmpty)
                    const Center(child: Text('No categories match your search.', style: TextStyle(color: Colors.grey)))
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: filteredCategories.length,
                      itemBuilder: (context, index) {
                        final cat = filteredCategories[index];
                        return _buildCategoryCard(cat, context);
                      },
                    ),
                  const SizedBox(height: 32),
                  // ... rest remains same
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [SkillSwapColors.primary, Color(0xFF6366F1)]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (Navigator.canPop(context))
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              const Text('Explore Skills',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            onChanged: (value) => setState(() => searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search any skill...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> cat, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/skill-exchange', arguments: cat['name']);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))
          ],
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(cat['icon'], style: const TextStyle(fontSize: 24)),
              Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      color: cat['color'], shape: BoxShape.circle)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(cat['name'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              Text('${cat['count']} teachers',
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6), fontSize: 10)),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildTrendingItem(String skill, int learners, String type, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/skill-exchange', arguments: skill);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(skill, style: const TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  const Icon(Icons.people_outline,
                      size: 14, color: Colors.grey),
                  Text(' $learners learners',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          if (type == 'exchange' || type == 'both')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: SkillSwapColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: const Text('Exchange',
                  style: TextStyle(
                      color: SkillSwapColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      ),
    );
  }
}
