import 'package:flutter/material.dart';

// Widget độc lập, có thể dùng trong bất kỳ màn hình nào
class ToursSection extends StatelessWidget {
  final String city;

  const ToursSection({super.key, this.city = 'Danang'});

  final List<Map<String, dynamic>> _tours = const [
    {
      'title': 'Da Nang - Ba Na - Hoi An',
      'date': 'Jan 30, 2020',
      'days': 3,
      'price': 400.00,
      'likes': 1247,
      'rating': 4,
      'isFavorite': false,
      'image': 'assets/images/search/tour/199641361 1-1.png',
    },
    {
      'title': 'Melbourne - Sydney',
      'date': 'Jan 30, 2020',
      'days': 3,
      'price': 600.00,
      'likes': 1047,
      'rating': 4,
      'isFavorite': true,
      'image': 'assets/images/search/tour/199641361 1-2.png',
    },
    {
      'title': 'Hanoi - Ha Long Bay',
      'date': 'Jan 30, 2020',
      'days': 3,
      'price': 300.00,
      'likes': 1247,
      'rating': 5,
      'isFavorite': false,
      'image':
          'assets/images/search/tour/halong-bay-vietnam-from-above-gettyimages 1 (1).png',
    },
    {
      'title': 'Da Nang - Ba Na - Hoi An',
      'date': 'Jan 30, 2020',
      'days': 3,
      'price': 400.00,
      'likes': 1247,
      'rating': 4,
      'isFavorite': false,
      'image': 'assets/images/search/tour/199641361 1.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tours in $city',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'SEE MORE',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00C9A7),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Tour list
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _tours.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return _TourCard(tour: _tours[index]);
          },
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}

class _TourCard extends StatefulWidget {
  final Map<String, dynamic> tour;

  const _TourCard({required this.tour});

  @override
  State<_TourCard> createState() => _TourCardState();
}

class _TourCardState extends State<_TourCard> {
  late bool _isFavorite;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.tour['isFavorite'] as bool;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: navigate to tour detail
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                  child: Image.asset(
                    widget.tour['image'],
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Bookmark icon top-right
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => setState(() => _isSaved = !_isSaved),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isSaved ? Icons.bookmark : Icons.bookmark_border,
                        size: 18,
                        color: _isSaved
                            ? const Color(0xFF00C9A7)
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                ),

                // Rating + likes bottom-left
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < (widget.tour['rating'] as int)
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 14,
                          );
                        }),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.tour['likes']} likes',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(color: Colors.black54, blurRadius: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Info section
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + favorite
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.tour['title'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => setState(() => _isFavorite = !_isFavorite),
                        child: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: _isFavorite
                              ? const Color(0xFF00C9A7)
                              : Colors.grey[400],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Date & Duration + Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 13,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.tour['date'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Days
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 13,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.tour['days']} days',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Price
                      Text(
                        '\$${widget.tour['price'].toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00C9A7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
