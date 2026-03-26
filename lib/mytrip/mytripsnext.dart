import 'package:flutter/material.dart';
import 'package:ktck/login/explore/explore.dart';
import 'package:ktck/mytrip/mytripscurrent.dart';
import 'package:ktck/mytrip/mytripspast.dart';
import 'package:ktck/mytrip/mytripswishlish.dart';

class MyTripsNext extends StatefulWidget {
  const MyTripsNext({super.key});

  @override
  State<MyTripsNext> createState() => _MyTripsNextScreenState();
}

class _MyTripsNextScreenState extends State<MyTripsNext> {
  int _selectedTab = 1; // Next Trips selected
  int _selectedNavIndex = 1;

  final List<String> _tabs = [
    'Current Trips',
    'Next Trips',
    'Past Trips',
    'Wish List',
  ];

  final List<Map<String, dynamic>> _trips = [
    {
      'title': 'Ho Guom Trip',
      'image': 'assets/images/mytrip/mytripnext/dragon-bridge-03 2.png',
      'location': 'Hanoi, Vietnam',
      'date': 'Feb 2, 2020',
      'time': '8:00 - 10:00',
      'guide': 'Emmy',
      'avatar': 'assets/images/explore/BestGuides/Emmy 1.png',
      'status': null,
      'extraAvatars': 0,
      'actions': ['Detail', 'Chat', 'Pay'],
    },
    {
      'title': 'Ho Chi Minh Mausoleum',
      'image': 'assets/images/mytrip/mytripnext/dragon-bridge-03 2-1.png',
      'location': 'Hanoi, Vietnam',
      'date': 'Feb 2, 2020',
      'time': '8:00 - 10:00',
      'guide': 'Emmy',
      'avatar': 'assets/images/explore/BestGuides/Emmy 1.png',
      'status': 'Waiting',
      'extraAvatars': 0,
      'actions': ['Detail'],
    },
    {
      'title': 'Duc Ba Church',
      'image':
          'assets/images/mytrip/mytripnext/20161021091303-nha-tho-duc-ba-gody (7) 1.png',
      'location': 'Ho Chi Minh, Vietnam',
      'date': 'Feb 2, 2020',
      'time': '8:00 - 10:00',
      'guide': 'Waiting for offers',
      'avatar': 'assets/images/explore/BestGuides/Khai 1.png',
      'status': 'Bidding',
      'extraAvatars': 3,
      'actions': ['Detail', 'Chat'],
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
                if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyTripsPast()),
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
          // Trip image with overlays
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(
                  trip['image'],
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 140,
                    color: Colors.teal[100],
                    child: const Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Status badge (Waiting / Bidding)
              if (trip['status'] != null)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: trip['status'] == 'Bidding'
                          ? const Color(0xFF5C6BC0)
                          : Colors.grey[600],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      trip['status'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              // More options button (first card only)
              if (trip['status'] == null)
                Positioned(
                  top: 10,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _Dot(),
                        SizedBox(width: 3),
                        _Dot(),
                        SizedBox(width: 3),
                        _Dot(),
                      ],
                    ),
                  ),
                ),
              // Location label
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info
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
                      const SizedBox(height: 12),
                      // Action buttons
                      _buildActionButtons(trip['actions']),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Avatar(s)
                _buildAvatarStack(trip),
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

  Widget _buildActionButtons(List<dynamic> actions) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: actions.map<Widget>((action) {
        return OutlinedButton.icon(
          onPressed: () {},
          icon: Icon(_actionIcon(action), size: 14),
          label: Text(action),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF00BFA5),
            side: const BorderSide(color: Color(0xFF00BFA5), width: 1),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _actionIcon(String action) {
    switch (action) {
      case 'Chat':
        return Icons.chat_bubble_outline;
      case 'Pay':
        return Icons.payment_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Widget _buildAvatarStack(Map<String, dynamic> trip) {
    final int extra = trip['extraAvatars'] as int;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: const Color(0xFF00BFA5),
          child: CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(trip['avatar']),
            onBackgroundImageError: (_, __) {},
          ),
        ),
        if (extra > 0)
          Positioned(
            right: -6,
            bottom: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF00BFA5),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Center(
                child: Text(
                  '+$extra',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
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

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}
