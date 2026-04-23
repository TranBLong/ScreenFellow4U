import 'package:flutter/material.dart';
import 'package:ktck/tourdetail/tourdetail.dart';

class TopJourneysWidget extends StatelessWidget {
  const TopJourneysWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
              children: [
                _buildJourneyCard(
                  context: context,
                  image: "assets/images/explore/TopJourneys/670301139 1.png",
                  title: "Da Nang - Ba Na - Hoi An",
                  date: "Jan 30, 2020",
                  duration: "3 days",
                  price: "\$400.00",
                ),
                _buildJourneyCard(
                  context: context,
                  image:
                      "https://cdn.nhandan.vn/images/1ea1ae7a315d88fc6fbf436960826115d9db77fae530c97a0f41bf87fc71014c3c08f01b123175d18261c3073b03704ae667d376bf869970b83bd2a9ea12e0ea/4-902-6587.jpg",
                  title: "Thailand",
                  date: "Jan 30, 2020",
                  duration: "3 days",
                  price: "\$600.00",
                ),
                _buildJourneyCard(
                  context: context,
                  image:
                      "https://cdn.nhandan.vn/images/1ea1ae7a315d88fc6fbf436960826115d9db77fae530c97a0f41bf87fc71014c3c08f01b123175d18261c3073b03704ae667d376bf869970b83bd2a9ea12e0ea/4-902-6587.jpg",
                  title: "Bali - Ubud - Kuta",
                  date: "Feb 10, 2020",
                  duration: "4 days",
                  price: "\$520.00",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJourneyCard({
    required BuildContext context,
    required String image,
    required String title,
    required String date,
    required String duration,
    required String price,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TourDetailScreen(
              tourData: {
                'Title': title,
                'CoverImageUrl': image,
                'DepartureDate': date,
                'Duration': duration,
                'Price': price.replaceAll('\$', ''),
                'OriginalPrice': price.replaceAll('\$', ''),
                'Rating': 4.5,
                'TotalReviews': 1247,
                'ProviderName': 'Featured tour',
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
                  child: image.startsWith("http")
                      ? Image.network(
                          image,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          image,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
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
                      (index) => const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    "1247 likes",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
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
