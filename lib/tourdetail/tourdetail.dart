import 'package:flutter/material.dart';
import 'package:ktck/login/explore/explore.dart';
import 'package:ktck/tourdetail/schedule_price.dart';
import 'package:ktck/tourdetail/share.dart';

class TourDetailScreen extends StatefulWidget {
  const TourDetailScreen({super.key});

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  bool _isFavorite = false;
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const Explore()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C9A7),
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'BOOK THIS TOUR',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Image with back button
                    Stack(
                      children: [
                        ClipRRect(
                          child: Image.asset(
                            'assets/images/explore/TopJourneys/670301139 1.png',
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 220,
                                color: Colors.blue[200],
                                child: Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // Back button
                        Positioned(
                          top: 12,
                          left: 12,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.85),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                size: 18,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        // Action buttons
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Row(
                            children: [
                              _iconButton(
                                Icons.share_outlined,
                                onTap: () => showShareBottomSheet(context),
                              ),
                              const SizedBox(width: 8),
                              _iconButton(
                                _isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                active: _isFavorite,
                                activeColor: Colors.red,
                                onTap: () {
                                  setState(() => _isFavorite = !_isFavorite);
                                },
                              ),
                              const SizedBox(width: 8),
                              _iconButton(
                                _isBookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                active: _isBookmarked,
                                activeColor: const Color(0xFF00CEA6),
                                onTap: () {
                                  setState(
                                    () => _isBookmarked = !_isBookmarked,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & Price
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'Da Nang - Ba Na - Hoi An',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$400.00',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF00CEA6),
                                    ),
                                  ),
                                  Text(
                                    '\$460.00',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Rating & Reviews
                          Row(
                            children: [
                              ...List.generate(
                                4,
                                (i) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                              ),
                              Icon(
                                Icons.star_half,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '145 Reviews',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          // Provider
                          Row(
                            children: [
                              Text(
                                'Provider  ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                'dulichviet',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF00CEA6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Summary section
                          Text(
                            'Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 16),

                          _summaryRow('Itinerary', 'Da Nang - Ba Na - Hoi An'),
                          _divider(),
                          _summaryRow('Duration', '2 days, 2 nights'),
                          _divider(),
                          _summaryRow('Departure Date', 'Feb 12'),
                          _divider(),
                          _summaryRow('Departure Place', 'Ho Chi Minh'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const TourScheduleSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(
    IconData icon, {
    bool active = false,
    Color activeColor = Colors.black87,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: active ? activeColor : Colors.black87,
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 15, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 1, color: Colors.grey[200]);
  }
}
