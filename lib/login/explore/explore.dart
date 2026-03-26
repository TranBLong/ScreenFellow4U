import 'package:flutter/material.dart';
import 'top_journeys.dart';
import 'best_guides.dart';
import 'top_experiences.dart';
import 'featured_tours.dart';
import 'travel_news.dart';
import 'package:ktck/searchsystem/search.dart';
import 'package:ktck/mytrip/mytripscurrent.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(size),
          _buildHeader(),
          _buildWhiteContainer(),
          _buildSearchBar(context),
          _buildContent(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBackground(Size size) {
    return Positioned(
      top: 0,
      child: Image.asset(
        'assets/images/explore/image 3.png',
        width: size.width,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 40,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Explore",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: const [
                  Icon(Icons.location_on, color: Colors.white, size: 18),
                  SizedBox(width: 4),
                  Text(
                    "Da Nang",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Row(
                children: const [
                  Icon(Icons.cloud, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    "26 C",
                    style: TextStyle(color: Colors.white, fontSize: 35),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteContainer() {
    return Positioned(
      top: 140,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Positioned(
      top: 120,
      left: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: 343,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Color.fromARGB(255, 80, 80, 80)),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                readOnly: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
                  );
                },
                decoration: const InputDecoration(
                  hintText: "Hi, where do you want to explore?",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Positioned(
      top: 200,
      left: 0,
      right: 0,
      bottom: 0,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const TopJourneysWidget(),
          const SizedBox(height: 14),
          const BestGuidesWidget(),
          const SizedBox(height: 14),
          const TopExperiencesWidget(),
          const SizedBox(height: 0),
          const FeaturedToursWidget(),
          const SizedBox(height: 14),
          const TravelNewsWidget(),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final items = [
      Icons.explore_outlined,
      Icons.location_on,
      Icons.chat_bubble_outline,
      Icons.notifications_none,
      Icons.person_outline,
    ];

    final labels = ['Explore', '', '', '', ''];
    const selectedIndex = 0;

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
                  if (index == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyTripsCurrent()),
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
