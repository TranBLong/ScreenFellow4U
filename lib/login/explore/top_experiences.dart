import 'package:flutter/material.dart';
import 'package:ktck/tourdetail/tourdetail.dart';

class TopExperiencesWidget extends StatelessWidget {
  const TopExperiencesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Top Experiences",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "SEE MORE",
              style: TextStyle(
                color: Color(0xFF00CEA6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 320,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildExperienceCard(
                  context: context,
                  image: "assets/images/explore/TopExperiences/hoian 1.png",
                  avatar: "assets/images/explore/BestGuides/Tuan Tran 1.png",
                  name: "Tuan Tran",
                  title: "2 Hour Bicycle Tour exploring Hoian",
                  location: "Hoian, Vietnam",
                ),
                _buildExperienceCard(
                  context: context,
                  image: "assets/images/explore/TopExperiences/hoian 1 (1).png",
                  avatar: "assets/images/explore/BestGuides/Linh Ho 1.png",
                  name: "Linh Hana",
                  title: "1 day at Bana Hill",
                  location: "Bana, Vietnam",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceCard({
    required BuildContext context,
    required String image,
    required String avatar,
    required String name,
    required String title,
    required String location,
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
                'Price': '0',
                'Rating': 4.5,
                'TotalReviews': 0,
                'ProviderName': name,
                'Itinerary': title,
                'DeparturePlace': location,
                'Description': title,
              },
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
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
                  bottom: -25,
                  left: 20,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: avatar.startsWith("http")
                              ? NetworkImage(avatar)
                              : AssetImage(avatar) as ImageProvider,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF00CEA6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 14,
                  color: Color(0xFF00CEA6),
                ),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF00CEA6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
