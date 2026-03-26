import 'package:flutter/material.dart';

class TravelNewsWidget extends StatelessWidget {
  const TravelNewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Travel News",
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
          const SizedBox(height: 16),
          _buildNewsItem(
            title: "New Destination in Danang City",
            date: "Feb 5, 2020",
            image:
                "assets/images/explore/TravelNews/cungvanhoathieunhi-danang-vntrip 1.png",
          ),
          const SizedBox(height: 16),
          _buildNewsItem(
            title: "\$1 Flight Ticket",
            date: "Feb 5, 2020",
            image:
                "assets/images/explore/TravelNews/cungvanhoathieunhi-danang-vntrip 1 (1).png",
          ),
          const SizedBox(height: 16),
          _buildNewsItem(
            title: "Visit Korea in this Tet Holiday",
            date: "Jan 26, 2020",
            image:
                "assets/images/explore/TravelNews/cungvanhoathieunhi-danang-vntrip 1 (2).png",
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem({
    required String title,
    required String date,
    required String image,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(date, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            image,
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
