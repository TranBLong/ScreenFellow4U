import 'package:flutter/material.dart';
import 'package:ktck/api_service.dart';
import 'package:ktck/login/explore/explore.dart';
import 'package:ktck/tourdetail/schedule_price.dart';
import 'package:ktck/tourdetail/share.dart';

class TourDetailScreen extends StatefulWidget {
  final int? tourId;
  final Map<String, dynamic>? tourData;

  const TourDetailScreen({super.key, this.tourId, this.tourData});

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  late final Future<Map<String, dynamic>> _detailFuture;
  bool _isFavorite = false;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _detailFuture = _loadTourDetail();
  }

  Future<Map<String, dynamic>> _loadTourDetail() async {
    if (widget.tourId != null) {
      final response = await ApiService.getTourById(widget.tourId!);
      if (response['success'] == true && response['data'] is Map) {
        return Map<String, dynamic>.from(response['data'] as Map);
      }
    }

    final fallback = widget.tourData;
    if (fallback != null) {
      return {
        'tour': fallback,
        'images': fallback['images'] ?? const [],
        'schedules': fallback['schedules'] ?? const [],
        'pricing': fallback['pricing'] ?? const [],
        'reviews': fallback['reviews'] ?? const [],
      };
    }

    throw Exception('Tour details are not available');
  }

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
            child: const Text(
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
        child: FutureBuilder<Map<String, dynamic>>(
          future: _detailFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF00C9A7)),
              );
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return _buildErrorView(context, snapshot.error);
            }

            final detail = snapshot.data!;
            final tour = Map<String, dynamic>.from(
              (detail['tour'] as Map?) ?? const {},
            );
            final images = _listOfMaps(detail['images']);
            final schedules = _listOfMaps(detail['schedules']);
            final pricing = _listOfMaps(detail['pricing']);
            final reviews = _listOfMaps(detail['reviews']);

            final title = _stringValue(tour, ['Title', 'title'], 'Untitled tour');
            final price = _numberValue(tour, ['Price', 'price']);
            final originalPrice = _numberValue(
              tour,
              ['OriginalPrice', 'originalPrice'],
            );
            final rating = _numberValue(tour, ['Rating', 'rating']);
            final totalReviews = _intValue(
              tour,
              ['TotalReviews', 'totalReviews'],
            );
            final provider = _stringValue(
              tour,
              ['ProviderName', 'providerName'],
              'Unknown provider',
            );
            final itinerary = _stringValue(
              tour,
              ['Itinerary', 'itinerary'],
              'No itinerary available',
            );
            final departureDate = _stringValue(
              tour,
              ['DepartureDate', 'departureDate'],
              'N/A',
            );
            final departurePlace = _stringValue(
              tour,
              ['DeparturePlace', 'departurePlace'],
              'N/A',
            );
            final duration = _stringValue(
              tour,
              ['Duration', 'duration'],
              'N/A',
            );
            final description = _stringValue(
              tour,
              ['Description', 'description'],
              'No description available',
            );
            final coverImage = _resolveCoverImage(tour, images);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            _buildImage(coverImage, height: 220),
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
                                  child: const Icon(
                                    Icons.arrow_back_ios_new,
                                    size: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      title,
                                      style: const TextStyle(
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
                                        _formatPrice(price),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF00CEA6),
                                        ),
                                      ),
                                      if (originalPrice > price)
                                        Text(
                                          _formatPrice(originalPrice),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  ...List.generate(
                                    rating.floor().clamp(0, 5).toInt(),
                                    (_) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                  ),
                                  if (rating - rating.floor() >= 0.5)
                                    const Icon(
                                      Icons.star_half,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '$totalReviews Reviews',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
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
                                    provider,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF00CEA6),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Summary',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _summaryRow('Itinerary', itinerary),
                              _divider(),
                              _summaryRow('Duration', duration),
                              _divider(),
                              _summaryRow('Departure Date', departureDate),
                              _divider(),
                              _summaryRow('Departure Place', departurePlace),
                              const SizedBox(height: 16),
                              Text(
                                description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TourScheduleSection(
                          schedules: schedules,
                          pricing: pricing,
                        ),
                        if (reviews.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Reviews',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...reviews.take(3).map((review) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _stringValue(
                                              review,
                                              ['FullName', 'fullName'],
                                              'Anonymous',
                                            ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _stringValue(
                                              review,
                                              ['Comment', 'comment'],
                                              '',
                                            ),
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, Object? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 42, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(
              error?.toString() ?? 'Failed to load tour details',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go back'),
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
          Text(value, style: const TextStyle(fontSize: 15, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 1, color: Colors.grey[200]);
  }

  Widget _buildImage(String? imageUrl, {required double height}) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        height: height,
        width: double.infinity,
        color: Colors.blueGrey.shade200,
        child: const Center(
          child: Icon(Icons.image, size: 60, color: Colors.white),
        ),
      );
    }

    final widget = imageUrl.startsWith('http')
        ? Image.network(
            imageUrl,
            height: height,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildImage(null, height: height),
          )
        : Image.asset(
            imageUrl,
            height: height,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildImage(null, height: height),
          );

    return ClipRRect(child: widget);
  }

  String? _resolveCoverImage(
    Map<String, dynamic> tour,
    List<Map<String, dynamic>> images,
  ) {
    if (images.isNotEmpty) {
      final first = images.first;
      final imageUrl = first['ImageUrl'] ?? first['imageUrl'];
      if (imageUrl != null && imageUrl.toString().isNotEmpty) {
        return imageUrl.toString();
      }
    }

    final coverImage = tour['CoverImageUrl'] ?? tour['coverImageUrl'];
    if (coverImage != null && coverImage.toString().isNotEmpty) {
      return coverImage.toString();
    }

    return null;
  }

  List<Map<String, dynamic>> _listOfMaps(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  String _stringValue(
    Map<String, dynamic> source,
    List<String> keys,
    String fallback,
  ) {
    for (final key in keys) {
      final value = source[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    return fallback;
  }

  double _numberValue(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = source[key];
      if (value == null) continue;
      final parsed = double.tryParse(value.toString());
      if (parsed != null) return parsed;
    }
    return 0;
  }

  int _intValue(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = source[key];
      if (value == null) continue;
      final parsed = int.tryParse(value.toString());
      if (parsed != null) return parsed;
    }
    return 0;
  }

  String _formatPrice(double value) {
    if (value == 0) return '\$0.00';
    return '\$${value.toStringAsFixed(2)}';
  }
}
