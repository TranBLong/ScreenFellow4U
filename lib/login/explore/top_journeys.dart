import 'package:flutter/material.dart';
import 'package:ktck/tourdetail/tourdetail.dart';
import 'package:ktck/api_service.dart';

class TopJourneysWidget extends StatefulWidget {
  const TopJourneysWidget({super.key});

  @override
  State<TopJourneysWidget> createState() => _TopJourneysWidgetState();
}

class _TopJourneysWidgetState extends State<TopJourneysWidget> {
  List<Map<String, dynamic>> _topJourneys = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTopJourneys();
  }

  Future<void> _fetchTopJourneys() async {
    try {
      final response = await ApiService.getAllTours(limit: 5);
      
      if (response['success'] == true) {
        final List<dynamic> toursData = response['data'] ?? [];
        setState(() {
          _topJourneys = toursData.map((tour) {
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
      print('Error fetching top journeys: $e');
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
        const Text(
          "Top Journeys",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 300,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _topJourneys.map((tour) {
                return _buildJourneyCard(
                  context: context,
                  tourId: tour['TourID'],
                  image: tour['image'],
                  title: tour['title'],
                  date: tour['date'],
                  duration: tour['duration'],
                  price: tour['price'],
                  rating: tour['rating'],
                  likes: tour['likes'],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJourneyCard({
    required BuildContext context,
    required dynamic tourId,
    required String image,
    required String title,
    required String date,
    required String duration,
    required String price,
    required int rating,
    required int likes,
  }) {
    // Handle image loading
    Widget imageWidget;
    if (image.isEmpty) {
      imageWidget = Container(
        height: 150,
        color: Colors.grey[300],
        child: const Icon(Icons.image, size: 50, color: Colors.white),
      );
    } else if (image.startsWith("http")) {
      imageWidget = Image.network(
        image,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 150,
          color: Colors.grey[300],
          child: const Icon(Icons.image, size: 50, color: Colors.white),
        ),
      );
    } else {
      imageWidget = Image.asset(
        image,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 150,
          color: Colors.grey[300],
          child: const Icon(Icons.image, size: 50, color: Colors.white),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TourDetailScreen(
              tourId: int.tryParse(tourId.toString()),
              tourData: {
                'Title': title,
                'CoverImageUrl': image,
                'DepartureDate': date,
                'Duration': duration,
                'Price': price.replaceAll('\$', ''),
                'OriginalPrice': price.replaceAll('\$', ''),
                'Rating': rating,
                'TotalReviews': likes,
                'ProviderName': 'Top journeys',
                'Itinerary': title,
                'Description': title,
              },
            ),
          ),
        );
      },
      child: Container(
        width: 250,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
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
                const Positioned(
                  top: 10,
                  right: 10,
                  child: Icon(Icons.bookmark_border, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  const SizedBox(width: 5),
                  Text(
                    "$likes likes",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                price,
                style: const TextStyle(
                  color: Color(0xFF00CEA6),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
