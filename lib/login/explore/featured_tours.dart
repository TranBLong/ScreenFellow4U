import 'package:flutter/material.dart';
import 'package:ktck/tourdetail/tourdetail.dart';
import 'package:ktck/seemore/toursmore.dart';
import 'package:ktck/api_service.dart';

class FeaturedToursWidget extends StatefulWidget {
  const FeaturedToursWidget({super.key});

  @override
  State<FeaturedToursWidget> createState() => _FeaturedToursWidgetState();
}

class _FeaturedToursWidgetState extends State<FeaturedToursWidget> {
  List<Map<String, dynamic>> _featuredTours = [];
  bool _isLoading = true;
  final Set<int> _favoredTourIds = {};
  final Set<int> _bookmarkedTourIds = {};

  @override
  void initState() {
    super.initState();
    _fetchFeaturedTours();
  }

  Future<void> _fetchFeaturedTours() async {
    try {
      final response = await ApiService.getAllTours(limit: 3);
      
      if (response['success'] == true) {
        final List<dynamic> toursData = response['data'] ?? [];
        setState(() {
          _featuredTours = toursData.map((tour) {
            return {
              'TourID': tour['TourID'],
              'title': tour['Title'] ?? 'Unknown Tour',
              'date': _formatDate(tour['DepartureDate']),
              'duration': '${tour['Duration'] ?? 0} days',
              'price': '\$${double.tryParse(tour['Price'].toString())?.toStringAsFixed(2) ?? "0.00"}',
              'image': tour['CoverImageUrl'] ?? '',
              'rating': (tour['Rating'] ?? 0).toInt(),
              'likes': tour['TotalLikes'] ?? 0,
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error fetching featured tours: $e');
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
    try {
      final DateTime parsedDate = DateTime.parse(date.toString());
      final List<String> months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[parsedDate.month - 1]} ${parsedDate.day}, ${parsedDate.year}';
    } catch (e) {
      return date.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF00C9A7)),
      );
    }

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
          children: _featuredTours.map((tour) {
            final isFavorite = _favoredTourIds.contains(tour['TourID']);
            final isBookmarked = _bookmarkedTourIds.contains(tour['TourID']);

            return _buildFeaturedCard(
              image: tour['image'] ?? '',
              title: tour['title'] ?? 'Unknown',
              date: tour['date'] ?? 'N/A',
              duration: tour['duration'] ?? 'N/A',
              price: tour['price'] ?? '\$0.00',
              isFavorite: isFavorite,
              isBookmarked: isBookmarked,
              rating: tour['rating'] ?? 0,
              likes: tour['likes'] ?? 0,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TourDetailScreen(
                      tourId: int.tryParse(tour['TourID'].toString()),
                      tourData: {
                        'Title': tour['title'],
                        'CoverImageUrl': tour['image'],
                        'DepartureDate': tour['date'],
                        'Duration': tour['duration'],
                        'Price': tour['price'] == null
                            ? null
                            : tour['price'].toString().replaceAll('\$', ''),
                        'Rating': tour['rating'],
                        'TotalReviews': tour['likes'],
                        'ProviderName': 'Featured tours',
                        'Itinerary': tour['title'],
                        'Description': tour['title'],
                      },
                    ),
                  ),
                );
              },
              onToggleFavorite: () {
                setState(() {
                  if (isFavorite) {
                    _favoredTourIds.remove(tour['TourID']);
                  } else {
                    _favoredTourIds.add(tour['TourID']);
                  }
                });
              },
              onToggleBookmark: () {
                setState(() {
                  if (isBookmarked) {
                    _bookmarkedTourIds.remove(tour['TourID']);
                  } else {
                    _bookmarkedTourIds.add(tour['TourID']);
                  }
                });
              },
            );
          }).toList(),
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
    required int rating,
    required int likes,
    required VoidCallback onTap,
    required VoidCallback onToggleFavorite,
    required VoidCallback onToggleBookmark,
  }) {
    // Handle image loading
    Widget imageWidget;
    if (image.isEmpty) {
      imageWidget = Container(
        height: 160,
        color: Colors.grey[300],
        child: const Icon(Icons.image, size: 50, color: Colors.white),
      );
    } else if (image.startsWith("http")) {
      imageWidget = Image.network(
        image,
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 160,
          color: Colors.grey[300],
          child: const Icon(Icons.image, size: 50, color: Colors.white),
        ),
      );
    } else {
      imageWidget = Image.asset(
        image,
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 160,
          color: Colors.grey[300],
          child: const Icon(Icons.image, size: 50, color: Colors.white),
        ),
      );
    }

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
                  child: imageWidget,
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
                          (index) => Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Colors.orange,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "$likes likes",
                        style: const TextStyle(color: Colors.white, fontSize: 12),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
