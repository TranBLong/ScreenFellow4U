import 'package:flutter/material.dart';
import '../../chooseaguide/guidepage/mainguidepage.dart';
import 'package:ktck/seemore/guidesmore.dart';

class BestGuidesWidget extends StatelessWidget {
  const BestGuidesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Best Guides",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GuidesMoreScreen()),
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
        const SizedBox(height: 0),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 0,
          childAspectRatio: 0.75,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildGuideCard(
              context: context,
              image: "assets/images/explore/BestGuides/Tuan Tran 1.png",
              name: "Tuan Tran",
              location: "Danang, Vietnam",
            ),
            _buildGuideCard(
              context: context,
              image: "assets/images/explore/BestGuides/Emmy 1.png",
              name: "Emmy",
              location: "Hanoi, Vietnam",
            ),
            _buildGuideCard(
              context: context,
              image: "assets/images/explore/BestGuides/Linh Ho 1.png",
              name: "Linh Hana",
              location: "Danang, Vietnam",
            ),
            _buildGuideCard(
              context: context,
              image: "assets/images/explore/BestGuides/Khai 1.png",
              name: "Khai Ho",
              location: "Ho Chi Minh, Vietnam",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGuideCard({
    required String image,
    required String name,
    required String location,
    required BuildContext context, // thêm dòng này
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Mainguidepage()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: image.startsWith("http")
                ? Image.network(
                    image,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    image,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(
              5,
              (index) => const Icon(Icons.star, color: Colors.orange, size: 14),
            ),
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: Color(0xFF00CEA6)),
              const SizedBox(width: 4),
              Text(
                location,
                style: const TextStyle(fontSize: 12, color: Color(0xFF00CEA6)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
