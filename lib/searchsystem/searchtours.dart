import 'package:flutter/material.dart';

import 'package:ktck/api_service.dart';
import 'package:ktck/models/tour.dart';
import 'package:ktck/tourdetail/tourdetail.dart';

// Widget độc lập, có thể dùng trong bất kỳ màn hình nào
class ToursSection extends StatefulWidget {
  final String city;

  const ToursSection({super.key, this.city = 'Danang'});

  @override
  State<ToursSection> createState() => _ToursSectionState();
}

class _ToursSectionState extends State<ToursSection> {
  List<Tour> _tours = [];
  bool _isLoadingTours = true;

  @override
  void initState() {
    super.initState();
    _fetchTours();
  }

  Future<void> _fetchTours() async {
    setState(() => _isLoadingTours = true);
    final response = await ApiService.getAllTours(search: widget.city);
    
    final success = response['success'];
    final isSuccess = success == true || success == 1 || success == 'true';
    if (!isSuccess) {
      if (mounted) setState(() => _isLoadingTours = false);
      return;
    }

    final rawItems = _extractItems(response);
    final tours = rawItems
        .whereType<Map<String, dynamic>>()
        .map(Tour.fromJson)
        .toList();

    if (mounted) {
      setState(() {
        _tours = tours;
        _isLoadingTours = false;
      });
    }
  }

  List<Map<String, dynamic>> _extractItems(Map<String, dynamic> response) {
    final candidates = [
      response['data'],
      response['tours'],
      response['items'],
      response['result'],
    ];

    for (final candidate in candidates) {
      if (candidate is List) {
        return candidate
            .whereType<Map>()
            .map(
              (item) => Map<String, dynamic>.from(item.cast<String, dynamic>()),
            )
            .toList();
      }
      if (candidate is Map) {
        return [Map<String, dynamic>.from(candidate.cast<String, dynamic>())];
      }
    }

    return [];
  }

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
                'Tours in ${widget.city}',
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
        _isLoadingTours
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              )
            : _tours.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('No tours found.'),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _tours.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
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
  final Tour tour;

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
    _isFavorite = widget.tour.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.tour.id != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TourDetailScreen(tourId: widget.tour.id!),
            ),
          );
        }
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
                  child: _buildTourImage(widget.tour.coverImageUrl),
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
                            i < widget.tour.rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 14,
                          );
                        }),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.tour.totalLikes} likes',
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
                          widget.tour.title,
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
                                widget.tour.departureDate.isNotEmpty ? widget.tour.departureDate : 'N/A',
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
                                widget.tour.duration.isNotEmpty ? widget.tour.duration : 'N/A',
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
                        '\$${widget.tour.price.toStringAsFixed(2)}',
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

  Widget _buildTourImage(String imagePath) {
    if (imagePath.isEmpty) {
      return _fallback();
    }
    return imagePath.startsWith('http')
        ? Image.network(
            imagePath,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _fallback(),
          )
        : Image.asset(
            imagePath,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _fallback(),
          );
  }

  Widget _fallback() {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.grey[300],
      child: const Icon(
        Icons.image,
        size: 50,
        color: Colors.white,
      ),
    );
  }
}
