import 'package:flutter/material.dart';
import 'package:ktck/login/explore/explore.dart';
import 'package:ktck/mytrip/mytripscurrent.dart';
import 'package:ktck/mytrip/mytripsnext.dart';
import 'package:ktck/mytrip/mytripspast.dart';

class MyTripsWishlist extends StatefulWidget {
  const MyTripsWishlist({super.key});

  @override
  State<MyTripsWishlist> createState() => _MyTripsWishlistScreenState();
}

class _MyTripsWishlistScreenState extends State<MyTripsWishlist> {
  int _selectedTab = 3; // Wish List selected
  int _selectedNavIndex = 1;

  final List<String> _tabs = [
    'Current Trips',
    'Next Trips',
    'Past Trips',
    'Wish List',
  ];

  final List<Map<String, dynamic>> _wishlist = [
    {
      'title': 'Melbourne – Sydney',
      'image': 'assets/images/explore/FeaturedTours/199641361 1 (1).png',
      'date': 'Jan 30, 2020',
      'duration': '3 days',
      'price': '\$600.00',
      'rating': 4,
      'likes': '1247 likes',
      'liked': true,
      'bookmarked': false,
    },
    {
      'title': 'Hanoi – Ha Long Bay',
      'image':
          'assets/images/explore/FeaturedTours/halong-bay-vietnam-from-above-gettyimages 1.png',
      'date': 'Jan 30, 2020',
      'duration': '3 days',
      'price': '\$300.00',
      'rating': 4,
      'likes': '1247 likes',
      'liked': false,
      'bookmarked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: _wishlist.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildWishCard(index),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF00BFA5),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/explore/image 3.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.35),
              Colors.black.withOpacity(0.1),
            ],
          ),
        ),
        padding: const EdgeInsets.only(
          top: 48,
          left: 20,
          right: 20,
          bottom: 16,
        ),
        child: Stack(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My Trips',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyTripsCurrent()),
                  );
                  return;
                }
                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyTripsNext()),
                  );
                  return;
                }
                if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyTripsPast()),
                  );
                  return;
                }
                setState(() => _selectedTab = index);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF00BFA5)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontSize: 11,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWishCard(int index) {
    final trip = _wishlist[index];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with rating overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(
                  trip['image'],
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 160,
                    color: Colors.teal[100],
                    child: const Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Rating bar bottom-left
              Positioned(
                bottom: 10,
                left: 12,
                child: _buildRatingBar(trip['rating'], trip['likes']),
              ),
              // Bookmark icon top-right
              Positioned(
                top: 10,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _wishlist[index]['bookmarked'] =
                          !_wishlist[index]['bookmarked'];
                    });
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      trip['bookmarked']
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      size: 18,
                      color: const Color(0xFF00CEA6),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Card body
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row with heart
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        trip['title'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _wishlist[index]['liked'] =
                              !_wishlist[index]['liked'];
                        });
                      },
                      child: Icon(
                        trip['liked'] ? Icons.favorite : Icons.favorite_border,
                        color: trip['liked']
                            ? const Color(0xFF00CEA6)
                            : Colors.grey[400],
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Date
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 5),
                    Text(
                      trip['date'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Duration + Price row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 5),
                        Text(
                          trip['duration'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      trip['price'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00BFA5),
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

  Widget _buildRatingBar(int rating, String likes) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Stars
          ...List.generate(5, (i) {
            return Icon(
              i < rating ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 14,
            );
          }),
          const SizedBox(width: 6),
          Text(
            likes,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      Icons.explore_outlined,
      Icons.location_on,
      Icons.chat_bubble_outline,
      Icons.notifications_none,
      Icons.person_outline,
    ];
    final labels = ['', 'My Trips', '', '', ''];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = _selectedNavIndex == index;
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Explore()),
                    );
                    return;
                  }
                  setState(() => _selectedNavIndex = index);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      items[index],
                      color: isSelected
                          ? const Color(0xFF00BFA5)
                          : Colors.grey[400],
                      size: 26,
                    ),
                    if (labels[index].isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        labels[index],
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected
                              ? const Color(0xFF00BFA5)
                              : Colors.grey[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
