import 'package:flutter/material.dart';
import 'package:ktck/tourdetail/tourdetail.dart';
import 'package:ktck/seemore/toursmore.dart';

class FeaturedToursWidget extends StatefulWidget {
  const FeaturedToursWidget({super.key});

  @override
  State<FeaturedToursWidget> createState() => _FeaturedToursWidgetState();
}

class _FeaturedToursWidgetState extends State<FeaturedToursWidget> {
  final List<bool> _favorites = [false, true, false];
  final List<bool> _bookmarks = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Featured Tours",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ToursMoreScreen()),
                );
              },
              child: const Text(
                "SEE MORE",
                style: TextStyle(
                  color: Color(0xFF00CEA6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            _buildFeaturedCard(
              image: "assets/images/explore/FeaturedTours/199641361 1.png",
              title: "Da Nang - Ba Na - Hoi An",
              date: "Jan 30, 2020",
              duration: "3 days",
              price: "\$400.00",
              isFavorite: _favorites[0],
              isBookmarked: _bookmarks[0],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TourDetailScreen()),
                );
              },
              onToggleFavorite: () {
                setState(() => _favorites[0] = !_favorites[0]);
              },
              onToggleBookmark: () {
                setState(() => _bookmarks[0] = !_bookmarks[0]);
              },
            ),
            _buildFeaturedCard(
              image: "assets/images/explore/FeaturedTours/199641361 1 (1).png",
              title: "Melbourne - Sydney",
              date: "Jan 30, 2020",
              duration: "3 days",
              price: "\$600.00",
              isFavorite: _favorites[1],
              isBookmarked: _bookmarks[1],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TourDetailScreen()),
                );
              },
              onToggleFavorite: () {
                setState(() => _favorites[1] = !_favorites[1]);
              },
              onToggleBookmark: () {
                setState(() => _bookmarks[1] = !_bookmarks[1]);
              },
            ),
            _buildFeaturedCard(
              image:
                  "assets/images/explore/FeaturedTours/halong-bay-vietnam-from-above-gettyimages 1.png",
              title: "Hanoi - Ha Long Bay",
              date: "Jan 30, 2020",
              duration: "3 days",
              price: "\$300.00",
              isFavorite: _favorites[2],
              isBookmarked: _bookmarks[2],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TourDetailScreen()),
                );
              },
              onToggleFavorite: () {
                setState(() => _favorites[2] = !_favorites[2]);
              },
              onToggleBookmark: () {
                setState(() => _bookmarks[2] = !_bookmarks[2]);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeaturedCard({
    required String image,
    required String title,
    required String date,
    required String duration,
    required String price,
    required bool isFavorite,
    required bool isBookmarked,
    required VoidCallback onTap,
    required VoidCallback onToggleFavorite,
    required VoidCallback onToggleBookmark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: image.startsWith("http")
                      ? Image.network(
                          image,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          image,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: InkWell(
                    onTap: onToggleBookmark,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Row(
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "1247 likes",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onToggleFavorite,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: const Color(0xFF00CEA6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    date,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    duration,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                price,
                style: const TextStyle(
                  color: Color(0xFF00CEA6),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
