import 'package:flutter/material.dart';

class GuidesMoreScreen extends StatefulWidget {
  const GuidesMoreScreen({super.key});

  @override
  State<GuidesMoreScreen> createState() => _GuidesMoreScreenState();
}

class _GuidesMoreScreenState extends State<GuidesMoreScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _guides = [
    {
      'name': 'Tuan Tran',
      'location': 'Danang, Vietnam',
      'rating': 5,
      'reviews': 127,
      'image': 'assets/images/explore/BestGuides/Tuan Tran 1.png',
    },
    {
      'name': 'Emmy',
      'location': 'Hanoi, Vietnam',
      'rating': 4,
      'reviews': 98,
      'image': 'assets/images/explore/BestGuides/Emmy 1.png',
    },
    {
      'name': 'Linh Hana',
      'location': 'Danang, Vietnam',
      'rating': 4,
      'reviews': 115,
      'image': 'assets/images/explore/BestGuides/Linh Ho 1.png',
    },
    {
      'name': 'Khai Ho',
      'location': 'Ho Chi Minh, Vietnam',
      'rating': 4,
      'reviews': 127,
      'image': 'assets/images/explore/BestGuides/Khai 1.png',
    },
    {
      'name': 'Tuan Tran',
      'location': 'Danang, Vietnam',
      'rating': 5,
      'reviews': 127,
      'image': 'assets/images/explore/BestGuides/Tuan Tran 1.png',
    },
    {
      'name': 'Emmy',
      'location': 'Hanoi, Vietnam',
      'rating': 4,
      'reviews': 98,
      'image': 'assets/images/explore/BestGuides/Emmy 1.png',
    },
    {
      'name': 'Linh Hana',
      'location': 'Danang, Vietnam',
      'rating': 4,
      'reviews': 115,
      'image': 'assets/images/explore/BestGuides/Linh Ho 1.png',
    },
    {
      'name': 'Khai Ho',
      'location': 'Ho Chi Minh, Vietnam',
      'rating': 4,
      'reviews': 127,
      'image': 'assets/images/explore/BestGuides/Khai 1.png',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Hero header
          SliverToBoxAdapter(
            child: Stack(
              children: [
                // Background image
                Image.asset(
                  'assets/images/explore/BestGuides/670301139 1.png',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(height: 200, color: Colors.grey[400]),
                ),
                // Dark overlay
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.35),
                        Colors.black.withOpacity(0.55),
                      ],
                    ),
                  ),
                ),
                // Content
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back button
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Book your own private local\nGuide and explore the city',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Search bar
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                size: 18,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  style: const TextStyle(fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText:
                                        'Hi, where do you want to explore?',
                                    hintStyle: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[400],
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final guide = _guides[index];
                return _GuideCard(guide: guide);
              }, childCount: _guides.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.78,
              ),
            ),
          ),

          // Pagination dots
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == 0 ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == 0
                          ? const Color(0xFF00C9A7)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  final Map<String, dynamic> guide;

  const _GuideCard({required this.guide});

  @override
  Widget build(BuildContext context) {
    final imagePath = guide['image'] as String;
    final imageWidget = imagePath.startsWith('http')
        ? Image.network(
            imagePath,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
          )
        : Image.asset(
            imagePath,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
          );

    return GestureDetector(
      onTap: () {
        // TODO: navigate to guide detail
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageWidget,
                ),
                // Rating overlay
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < (guide['rating'] as int)
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 13,
                          );
                        }),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '${guide['reviews']} Reviews',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(color: Colors.black54, blurRadius: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Name
          Text(
            guide['name'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 2),

          // Location
          Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFF00C9A7), size: 13),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  guide['location'],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
