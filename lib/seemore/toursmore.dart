import 'package:flutter/material.dart';
import '../api_service.dart';

class ToursMoreScreen extends StatefulWidget {
  const ToursMoreScreen({super.key});

  @override
  State<ToursMoreScreen> createState() => _ToursMoreScreenState();
}

class _ToursMoreScreenState extends State<ToursMoreScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _tours = [];
  List<Map<String, dynamic>> _filteredTours = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  int _totalPages = 1;
  final Set<int> _favoredTourIds = {};

  @override
  void initState() {
    super.initState();
    _fetchTours();
    _searchController.addListener(_filterTours);
  }

  Future<void> _fetchTours({int page = 1}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService.getAllTours(
        page: page,
        limit: 10,
        search: _searchController.text,
      );

      if (response['success'] == true) {
        final List<dynamic> toursData = response['data'] ?? [];
        setState(() {
          _tours = toursData.map((tour) {
            final isFavorite = _favoredTourIds.contains(tour['TourID']);
            return {
              'TourID': tour['TourID'],
              'title': tour['Title'] ?? 'Unknown Tour',
              'date': _formatDate(tour['DepartureDate']),
              'days': tour['Duration'] ?? 0,
              'price': double.tryParse(tour['Price'].toString()) ?? 0.0,
              'likes': tour['TotalLikes'] ?? 0,
              'rating': (tour['Rating'] ?? 0).toInt(),
              'isFavorite': isFavorite,
              'image': tour['CoverImageUrl'] ?? '',
              'description': tour['Description'] ?? '',
            };
          }).toList();
          _filteredTours = List.from(_tours);
          _currentPage = page;
          _totalPages = response['pagination']?['totalPages'] ?? 1;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response['error'] ?? 'Failed to load tours';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
    try {
      final DateTime parsedDate = DateTime.parse(date.toString());
      final List<String> months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[parsedDate.month - 1]} ${parsedDate.day}, ${parsedDate.year}';
    } catch (e) {
      return date.toString();
    }
  }

  void _filterTours() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTours = _tours
          .where(
            (tour) =>
                tour['title'].toLowerCase().contains(query) ||
                tour['description'].toLowerCase().contains(query),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/explore/BestGuides/670301139 1.png',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(height: 200, color: Colors.blueGrey[300]),
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.55),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Plenty of amazing of tours are\nwaiting for you',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Search bar
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                size: 18,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  style: const TextStyle(fontSize: 14),
                                  onChanged: (_) => _filterTours(),
                                  decoration: InputDecoration(
                                    hintText:
                                        'Hi, where do you want to explore?',
                                    hintStyle: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[400],
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loading, Error, or Tour list
          if (_isLoading)
            SliverToBoxAdapter(
              child: Container(
                height: 400,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: Color(0xFF00C9A7),
                ),
              ),
            )
          else if (_errorMessage != null)
            SliverToBoxAdapter(
              child: Container(
                height: 400,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 50, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Error: $_errorMessage',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchTours,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            )
          else if (_filteredTours.isEmpty)
            SliverToBoxAdapter(
              child: Container(
                height: 400,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 50, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    const Text(
                      'No tours found',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _TourCard(
                      tour: _filteredTours[index],
                      onFavoriteToggle: () {
                        setState(() {
                          final tourId = _filteredTours[index]['TourID'];
                          if (_filteredTours[index]['isFavorite']) {
                            _favoredTourIds.remove(tourId);
                          } else {
                            _favoredTourIds.add(tourId);
                          }
                          _filteredTours[index]['isFavorite'] =
                              !_filteredTours[index]['isFavorite'];
                        });
                      },
                    ),
                  ),
                  childCount: _filteredTours.length,
                ),
              ),
            ),

          // Pagination dots
          if (!_isLoading && _filteredTours.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_currentPage > 1)
                      ElevatedButton(
                        onPressed: () => _fetchTours(page: _currentPage - 1),
                        child: const Text('Previous'),
                      ),
                    const SizedBox(width: 16),
                    Text(
                      'Page $_currentPage of $_totalPages',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 16),
                    if (_currentPage < _totalPages)
                      ElevatedButton(
                        onPressed: () => _fetchTours(page: _currentPage + 1),
                        child: const Text('Next'),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TourCard extends StatelessWidget {
  final Map<String, dynamic> tour;
  final VoidCallback onFavoriteToggle;

  const _TourCard({required this.tour, required this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    final imagePath = tour['image'] as String? ?? '';

    // Build image widget with fallback
    Widget imageWidget;
    if (imagePath.isEmpty) {
      imageWidget = Container(
        height: 175,
        color: Colors.grey[300],
        child: const Icon(Icons.image, size: 50, color: Colors.white),
      );
    } else if (imagePath.startsWith('http')) {
      imageWidget = Image.network(
        imagePath,
        height: 175,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 175,
          color: Colors.grey[300],
          child: const Icon(Icons.image, size: 50, color: Colors.white),
        ),
      );
    } else {
      imageWidget = Image.asset(
        imagePath,
        height: 175,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 175,
          color: Colors.grey[300],
          child: const Icon(Icons.image, size: 50, color: Colors.white),
        ),
      );
    }

    final bool isFav = tour['isFavorite'] as bool;
    final int rating = tour['rating'] as int? ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
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
                child: imageWidget,
              ),
              // Bookmark top-right
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.bookmark_border,
                    size: 18,
                    color: Colors.grey[600],
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
                          i < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 14,
                        );
                      }),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${tour['likes']} likes',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Info
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        tour['title'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onFavoriteToggle,
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: isFav
                            ? const Color(0xFF00C9A7)
                            : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 13,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              tour['date'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 13,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${tour['days']} days',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '\$${tour['price'].toStringAsFixed(2)}',
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
    );
  }
}
