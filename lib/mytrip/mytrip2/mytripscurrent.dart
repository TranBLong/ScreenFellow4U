import 'package:flutter/material.dart';
import 'package:ktck/login/explore/explore.dart';
import 'package:ktck/mytrip/creaternewtrip/creaternewtrip.dart';
import 'package:ktck/mytrip/curreenttripdetail/curreenttripdetail.dart';
import 'package:ktck/mytrip/database/trip_database.dart';
import 'package:ktck/mytrip/models/trip.dart';
import 'package:ktck/mytrip/mytrip2/mytripsnext.dart';
import 'package:ktck/mytrip/mytrip2/mytripspast.dart';
import 'package:ktck/mytrip/mytrip2/mytripswishlish.dart';

class MyTripsCurrent extends StatefulWidget {
  const MyTripsCurrent({super.key});

  @override
  State<MyTripsCurrent> createState() => _MyTripsCurrentState();
}

class _MyTripsCurrentState extends State<MyTripsCurrent> {
  int _selectedTab = 0;
  List<Trip> _trips = [];
  bool _isLoading = true;

  final List<String> _tabs = [
    'Current Trips',
    'Next Trips',
    'Past Trips',
    'Wish List',
  ];

  @override
  void initState() {
    super.initState();
    _refreshTrips();
  }

  Future<void> _refreshTrips() async {
    setState(() => _isLoading = true);
    _trips = await TripDatabase.instance.readAllTrips();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmDelete(Trip trip) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete trip'),
          content: const Text('Are you sure you want to delete this trip?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await TripDatabase.instance.delete(trip.id!);
      await _refreshTrips();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip deleted successfully.')),
      );
    }
  }

  Future<void> _openForm([Trip? trip]) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateNewTripScreen(trip: trip),
      ),
    );
    if (changed == true) {
      await _refreshTrips();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _trips.isEmpty
                      ? _buildEmptyState()
                      : ListView.separated(
                          itemCount: _trips.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            return _buildTripCard(_trips[index]);
                          },
                        ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        backgroundColor: const Color(0xFF00BFA5),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No trips found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text('Create a new trip to get started.'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _openForm(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C9A7),
            ),
            child: const Text('Add Trip'),
          ),
        ],
      ),
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
              Colors.black.withOpacity(0.3),
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
                  setState(() => _selectedTab = index);
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
                  color: isSelected ? const Color(0xFF00BFA5) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTripCard(Trip trip) {
    return GestureDetector(
      onTap: () async {
        final changed = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => CurrentTripDetailScreen(trip: trip),
          ),
        );
        if (changed == true) {
          await _refreshTrips();
        }
      },
      child: Container(
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
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.asset(
                'assets/images/mytrip/mytripcurrent/dragon-bridge-03 2.png',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 160,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 60, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip.location,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${trip.date} • ${trip.timeFrom} - ${trip.timeTo}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () => _openForm(trip),
                            icon: const Icon(Icons.edit, color: Color(0xFF00C9A7)),
                          ),
                          IconButton(
                            onPressed: () => _confirmDelete(trip),
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.grey[600], size: 18),
                      const SizedBox(width: 4),
                      Text('${trip.travelers} travelers', style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(width: 16),
                      Icon(Icons.language, color: Colors.grey[600], size: 18),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          trip.language,
                          style: TextStyle(color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${trip.fee.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00C9A7),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          trip.status,
                          style: const TextStyle(
                            color: Color(0xFF00C9A7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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

  Widget _buildBottomNav() {
    final items = [
      Icons.explore_outlined,
      Icons.location_on,
      Icons.chat_bubble_outline,
      Icons.notifications_none,
      Icons.person_outline,
    ];

    final labels = ['', 'My Trips', '', '', ''];
    const selectedIndex = 1;

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
              final isSelected = selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Explore()),
                    );
                  }
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
