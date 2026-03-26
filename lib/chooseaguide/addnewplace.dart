import 'package:flutter/material.dart';

const List<Map<String, String>> kAddNewPlaceLocations = [
  {
    'name': 'Cong Coffee',
    'image': 'assets/images/chooseaguide/tripinformation/concoffee.png',
  },
];

class AddNewPlaces extends StatefulWidget {
  const AddNewPlaces({super.key});

  @override
  State<AddNewPlaces> createState() => _AddNewPlacesState();
}

class _AddNewPlacesState extends State<AddNewPlaces> {
  // Giả lập dữ liệu các địa điểm
  final List<Map<String, String>> locations = kAddNewPlaceLocations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New Attractions',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Xử lý khi nhấn DONE
            },
            child: const Text(
              'DONE',
              style: TextStyle(
                color: Color(0xFF1ABC9C), // Màu xanh ngọc giống trong hình
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Ô Search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Type a Place',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(15),
                  suffixIcon: Icon(Icons.add_circle, color: Colors.grey[300]),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Danh sách các địa điểm đã chọn (Grid view)
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 cột
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.2,
                ),
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  return AttractionCard(
                    name: locations[index]['name']!,
                    // Sử dụng ảnh placeholder nếu chưa có ảnh thật
                    imageUrl:
                        'assets/images/chooseaguide/tripinformation/concoffee.png',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget con cho từng thẻ địa điểm
class AttractionCard extends StatelessWidget {
  final String name;
  final String imageUrl;

  const AttractionCard({super.key, required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        // Dấu tích xanh ở góc phải
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1ABC9C),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }
}



