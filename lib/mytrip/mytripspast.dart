import 'package:flutter/material.dart';
import 'package:ktck/login/explore/explore.dart';
import 'package:ktck/mytrip/mytripscurrent.dart';
import 'package:ktck/mytrip/mytripsnext.dart';
import 'package:ktck/mytrip/mytripswishlish.dart';

class MyTripsPast extends StatefulWidget {
  const MyTripsPast({super.key});

  @override
  State<MyTripsPast> createState() => _MyTripsPastScreenState();
}

class _MyTripsPastScreenState extends State<MyTripsPast> {
  int _selectedTab = 2; // Past Trips selected
  int _selectedNavIndex = 1;

  final List<String> _tabs = [
    'Current Trips',
    'Next Trips',
    'Past Trips',
    'Wish List',
  ];

  final List<Map<String, dynamic>> _trips = [
    {
      'title': 'Quoc Tu Giam Temple',
      'image': 'assets/images/mytrip/mytrippast/van-mieu-quoc-tu-giam 1.png',
      'location': 'Hanoi, Vietnam',
      'date': 'Feb 2, 2020',
      'time': '8:00 - 10:00',
      'guide': 'Emmy',
      'avatar': 'assets/images/explore/BestGuides/Emmy 1.png',
    },
    {
      'title': 'Dinh Doc Lap',
      'image': 'assets/images/mytrip/mytrippast/dinh-doc-lap 1.png',
      'location': 'Ho Chi Minh, Vietnam',
      'date': 'Feb 2, 2020',
      'time': '8:00 - 10:00',
      'guide': 'Khai Ho',
      'avatar': 'assets/images/explore/BestGuides/Khai 1.png',
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
              itemCount: _trips.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildTripCard(_trips[index]),
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
                if (index == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyTripsWishlist()),
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

  Widget _buildTripCard(Map<String, dynamic> trip) {
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
          // Trip image with location label
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(
                  trip['image'],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 150,
                    color: Colors.teal[100],
                    child: const Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Location label bottom-left
              Positioned(
                bottom: 10,
                left: 12,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 15,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trip['location'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.6),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Card body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Info column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip['title'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildInfoRow(
                        Icons.calendar_today_outlined,
                        trip['date'],
                      ),
                      const SizedBox(height: 3),
                      _buildInfoRow(Icons.access_time, trip['time']),
                      const SizedBox(height: 3),
                      _buildInfoRow(Icons.person_outline, trip['guide']),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Avatar
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFF00BFA5),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage(trip['avatar']),
                    onBackgroundImageError: (_, __) {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
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
