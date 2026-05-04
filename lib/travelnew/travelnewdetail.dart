import 'package:flutter/material.dart';

class TravelNewsDetailScreen extends StatelessWidget {
  final String? title;
  final String? date;
  final String? image;
  final String? content;

  const TravelNewsDetailScreen({
    super.key,
    this.title = "New Destination in Danang City",
    this.date = "Feb 5, 2020",
    this.image = "assets/images/explore/TravelNews/cungvanhoathieunhi-danang-vntrip 1.png",
    this.content = "Đà Nẵng is a coastal city in central Vietnam known for its sandy beaches and history as a French colonial port. It's a popular base for visiting the inland Bà Nà hills to the west of the city. Here, the hillside Hải Vân Pass has views of Da Nang Bay and the Marble Mountains.\n\nThese 5 limestone outcrops are topped with pagodas and hide caves containing Buddhist shrines. This new destination brings a modern breath to the city's tourism, featuring a beautiful architectural complex that attracts many young people and tourists to visit and take photos.",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Travel News",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Ảnh trên đầu
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  image ?? "assets/images/explore/TravelNews/cungvanhoathieunhi-danang-vntrip 1.png",
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.image, size: 50, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              // 2. Tiếp theo là ngày
              Text(
                date ?? "Feb 5, 2020",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),

              // Title (Tiêu đề bài viết)
              Text(
                title ?? "New Destination in Danang City",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // 3. Cuối là nội dung
              Text(
                content ?? "",
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
