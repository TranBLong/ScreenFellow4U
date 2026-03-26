import 'package:flutter/material.dart';

class ToursMoreScreen extends StatefulWidget {
  const ToursMoreScreen({super.key});

  @override
  State<ToursMoreScreen> createState() => _ToursMoreScreenState();
}

class _ToursMoreScreenState extends State<ToursMoreScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _tours = [
    {
      'title': 'Da Nang - Ba Na - Hoi An',
      'date': 'Jan 30, 2020',
      'days': 3,
      'price': 400.00,
      'likes': 1247,
      'rating': 4,
      'isFavorite': false,
      'image': 'assets/images/explore/FeaturedTours/199641361 1.png',
    },
    {
      'title': 'Melbourne - Sydney',
      'date': 'Jan 30, 2020',
      'days': 3,
      'price': 600.00,
      'likes': 1047,
      'rating': 4,
      'isFavorite': true,
      'image': 'assets/images/explore/FeaturedTours/199641361 1 (1).png',
    },
    {
      'title': 'Hanoi - Ha Long Bay',
      'date': 'Jan 30, 2020',
      'days': 3,
      'price': 300.00,
      'likes': 1247,
      'rating': 5,
      'isFavorite': false,
      'image':
          'assets/images/explore/FeaturedTours/halong-bay-vietnam-from-above-gettyimages 1.png',
    },
    {
      'title': 'Da Nang - Ba Na - Hoi An',
      'date': 'Jan 30, 2020',
      'days': 3,
      'price': 400.00,
      'likes': 1247,
      'rating': 4,
      'isFavorite': false,
      'image': 'assets/images/explore/FeaturedTours/199641361 1.png',
    },
    {
      'title': 'Melbourne - Sydney',
      'date': 'Jan 30, 2020',
      'days': 3,
      'price': 600.00,
      'likes': 1047,
      'rating': 4,
      'isFavorite': true,
      'image': 'assets/images/explore/FeaturedTours/199641361 1 (1).png',
    },
    {
      'title': 'Hanoi - Ha Long Bay',
      'date': 'Jan 30, 2020',
      'days': 3,
      'price': 300.00,
      'likes': 1247,
      'rating': 5,
      'isFavorite': false,
      'image':
          'assets/images/explore/FeaturedTours/halong-bay-vietnam-from-above-gettyimages 1.png',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/explore/BestGuides/670301139 1.png',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(height: 200, color: Colors.blueGrey[300]),
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.55),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          'Plenty of amazing of tours are\nwaiting for you',
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

          // Tour list
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _TourCard(
                    tour: _tours[index],
                    onFavoriteToggle: () {
                      setState(() {
                        _tours[index]['isFavorite'] =
                            !_tours[index]['isFavorite'];
                      });
                    },
                  ),
                ),
                childCount: _tours.length,
              ),
            ),
          ),

          // Pagination dots
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
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

class _TourCard extends StatelessWidget {
  final Map<String, dynamic> tour;
  final VoidCallback onFavoriteToggle;

  const _TourCard({required this.tour, required this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    final imagePath = tour['image'] as String;
    final imageWidget = imagePath.startsWith('http')
        ? Image.network(
            imagePath,
            height: 175,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 175,
              color: Colors.grey[300],
              child: const Icon(Icons.image, size: 50, color: Colors.white),
            ),
          )
        : Image.asset(
            imagePath,
            height: 175,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 175,
              color: Colors.grey[300],
              child: const Icon(Icons.image, size: 50, color: Colors.white),
            ),
          );

    final bool isFav = tour['isFavorite'] as bool;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                child: imageWidget,
              ),
              // Bookmark top-right
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.bookmark_border,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              // Rating + likes bottom-left
              Positioned(
                bottom: 10,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          i < (tour['rating'] as int)
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 14,
                        );
                      }),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${tour['likes']} likes',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Info
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        tour['title'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onFavoriteToggle,
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: isFav
                            ? const Color(0xFF00C9A7)
                            : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 13,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              tour['date'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 13,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${tour['days']} days',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '\$${tour['price'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00C9A7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
