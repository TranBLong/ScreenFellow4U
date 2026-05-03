import 'package:flutter/material.dart';
import 'package:ktck/searchsystem/filter.dart';
import 'package:ktck/searchsystem/searchtours.dart';
import 'package:ktck/api_service.dart';
import 'package:ktck/models/guide.dart';
import 'package:ktck/chooseaguide/guidepage/mainguidepage.dart';

class SearchResultScreen extends StatefulWidget {
  final String destination;

  const SearchResultScreen({super.key, required this.destination});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final TextEditingController _controller = TextEditingController();

  List<Guide> _guides = [];
  bool _isLoadingGuides = true;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.destination;
    _fetchGuides();
  }

  Future<void> _fetchGuides() async {
    setState(() => _isLoadingGuides = true);
    final response = await ApiService.getAllGuides(search: widget.destination);
    
    final success = response['success'];
    final isSuccess = success == true || success == 1 || success == 'true';
    if (!isSuccess) {
      if (mounted) setState(() => _isLoadingGuides = false);
      return;
    }

    final rawItems = _extractItems(response);
    final guides = rawItems
        .whereType<Map<String, dynamic>>()
        .map(Guide.fromSummaryJson)
        .toList();

    if (mounted) {
      setState(() {
        _guides = guides;
        _isLoadingGuides = false;
      });
    }
  }

  List<Map<String, dynamic>> _extractItems(Map<String, dynamic> response) {
    final candidates = [
      response['data'],
      response['guides'],
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Close button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 24, color: Colors.black87),
              ),
            ),

            const SizedBox(height: 16),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.search,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        onSubmitted: (value) {
                          final query = value.trim();
                          if (query.isNotEmpty) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SearchResultScreen(destination: query),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    // Clear button
                    GestureDetector(
                      onTap: () => _controller.clear(),
                      child: Icon(
                        Icons.cancel,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Filter button
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(6),
                      child: GestureDetector(
                        onTap: () => showFilterBottomSheet(context),
                        child: Icon(
                          Icons.tune,
                          color: Colors.grey[600],
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Section header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Guides in ${widget.destination}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'SEE MORE',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF00C9A7),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Grid + Tours
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _isLoadingGuides
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : _guides.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text('No guides found.'),
                              )
                            : GridView.builder(
                                itemCount: _guides.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 0.82,
                                    ),
                                itemBuilder: (context, index) {
                                  final guide = _guides[index];
                                  return _GuideCard(guide: guide);
                                },
                              ),
                  ),
                  const SizedBox(height: 40),
                  ToursSection(
                    city: widget.destination.split(',').first.trim(),
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

class _GuideCard extends StatelessWidget {
  final Guide guide;

  const _GuideCard({required this.guide});

  @override
  Widget build(BuildContext context) {
    final imagePath = guide.avatarImage.isNotEmpty ? guide.avatarImage : guide.image;
    final imageWidget = imagePath.isNotEmpty && imagePath.startsWith('http')
        ? Image.network(
            imagePath,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
          )
        : Image.asset(
            imagePath,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image with rating overlay
        Expanded(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageWidget,
              ),
              // Rating badge bottom-left
              Positioned(
                bottom: 8,
                left: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          i < guide.rating.round() ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 14,
                        );
                      }),
                    ),
                    Text(
                      '${guide.reviews} Reviews',
                      style: const TextStyle(
                        fontSize: 10,
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
        ),

        const SizedBox(height: 6),

        // Name
        GestureDetector(
          onTap: () {
            if (guide.id != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Mainguidepage(guide: guide),
                ),
              );
            }
          },
          child: Text(
            guide.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        const SizedBox(height: 2),

        // Location
        Row(
          children: [
            Icon(Icons.location_on, color: const Color(0xFF00C9A7), size: 13),
            const SizedBox(width: 2),
            Expanded(
              child: Text(
                guide.location,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
