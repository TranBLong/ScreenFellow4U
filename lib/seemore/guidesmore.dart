import 'package:flutter/material.dart';
import 'package:ktck/api_service.dart';
import 'package:ktck/chooseaguide/guidepage/mainguidepage.dart';
import 'package:ktck/models/guide.dart';

class GuidesMoreScreen extends StatefulWidget {
  const GuidesMoreScreen({super.key});

  @override
  State<GuidesMoreScreen> createState() => _GuidesMoreScreenState();
}

class _GuidesMoreScreenState extends State<GuidesMoreScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late Future<List<Guide>> _guidesFuture;

  @override
  void initState() {
    super.initState();
    _guidesFuture = _fetchGuides();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<Guide>> _fetchGuides({String search = ''}) async {
    final initialResponse = await ApiService.getAllGuides(
      page: 1,
      limit: 1,
      search: search,
    );

    final isSuccess = initialResponse['success'] == true ||
        initialResponse['success'] == 1 ||
        initialResponse['success'] == 'true';
    if (!isSuccess) {
      return [];
    }

    final total = _extractTotal(initialResponse);
    if (total <= 0) {
      return [];
    }

    final response = await ApiService.getAllGuides(
      page: 1,
      limit: total,
      search: search,
    );

    final responseSuccess = response['success'] == true ||
        response['success'] == 1 ||
        response['success'] == 'true';
    if (!responseSuccess) {
      return [];
    }

    return _extractGuideItems(response)
        .whereType<Map<String, dynamic>>()
        .map(Guide.fromSummaryJson)
        .toList();
  }

  int _extractTotal(Map<String, dynamic> response) {
    final pagination = response['pagination'];
    if (pagination is Map) {
      final total = pagination['total'];
      if (total is int) return total;
      return int.tryParse(total?.toString() ?? '') ?? 0;
    }

    final data = response['data'];
    if (data is List) {
      return data.length;
    }

    return 0;
  }

  List<Map<String, dynamic>> _extractGuideItems(Map<String, dynamic> response) {
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

  Future<void> _applySearch(String value) async {
    final query = value.trim();
    setState(() {
      _guidesFuture = _fetchGuides(search: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/explore/BestGuides/670301139 1.png',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      Container(height: 200, color: Colors.grey[400]),
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.35),
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
                          'Book your own private local\nGuide and explore the city',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
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
                                  textInputAction: TextInputAction.search,
                                  onSubmitted: _applySearch,
                                  style: const TextStyle(fontSize: 14),
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
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: FutureBuilder<List<Guide>>(
              future: _guidesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text('Failed to load guides: ${snapshot.error}'),
                    ),
                  );
                }

                final guides = snapshot.data ?? const <Guide>[];
                if (guides.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: Text('No guides available.')),
                    ),
                  );
                }

                return SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _GuideCard(guide: guides[index]);
                    },
                    childCount: guides.length,
                  ),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.78,
                  ),
                );
              },
            ),
          ),
        ],
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

    return GestureDetector(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _GuideCardImage(imagePath: imagePath),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < guide.rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '${guide.reviews} Reviews',
                        style: const TextStyle(
                          fontSize: 10,
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
          ),
          const SizedBox(height: 6),
          Text(
            guide.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFF00C9A7), size: 13),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  guide.location,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GuideCardImage extends StatelessWidget {
  final String imagePath;

  const _GuideCardImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return _fallback();
    }

    final image = imagePath.startsWith('http')
        ? Image.network(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (_, _, _) => _fallback(),
          )
        : Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (_, _, _) => _fallback(),
          );

    return image;
  }

  Widget _fallback() {
    return Container(
      color: Colors.grey[300],
      alignment: Alignment.center,
      child: const Icon(Icons.person, size: 50, color: Colors.white),
    );
  }
}
