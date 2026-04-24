import 'package:flutter/material.dart';
import 'package:ktck/api_service.dart';
import 'package:ktck/chooseaguide/guidepage/myexperiences.dart';
import 'package:ktck/chooseaguide/guidepage/reviews.dart';
import 'package:ktck/login/explore/explore.dart';
import 'package:ktck/models/guide.dart';
import '../tripinformation.dart';

class Mainguidepage extends StatefulWidget {
  final Guide guide;

  const Mainguidepage({super.key, required this.guide});

  @override
  State<Mainguidepage> createState() => _MainguidepageState();
}

class _MainguidepageState extends State<Mainguidepage> {
  late final Future<Guide> _guideFuture;

  @override
  void initState() {
    super.initState();
    _guideFuture = _loadGuide(widget.guide);
  }

  Future<Guide> _loadGuide(Guide guide) async {
    if (guide.id == null) {
      return guide;
    }

    final response = await ApiService.getGuideById(guide.id!);
    if (response['success'] != true || response['data'] == null) {
      return guide;
    }

    final data = response['data'] as Map<String, dynamic>;
    final guideJson = data['guide'] as Map<String, dynamic>;
    final mergedGuideJson = <String, dynamic>{...data, ...guideJson};
    final languages = <String>[];
    final pricing = <GuidePricing>[];
    final experiences = <GuideExperience>[];
    final reviewData = <GuideReview>[];

    if (data['languages'] is List) {
      languages.addAll(
        (data['languages'] as List)
            .map((item) => item['Language']?.toString() ?? '')
            .where((language) => language.isNotEmpty),
      );
    }

    if (data['pricing'] is List) {
      pricing.addAll(
        (data['pricing'] as List).map(
          (item) => GuidePricing.fromJson(item as Map<String, dynamic>),
        ),
      );
    }

    final experienceImageMap = <int, List<String>>{};
    if (data['experienceImages'] is List) {
      for (final item in data['experienceImages'] as List) {
        final image = item as Map<String, dynamic>;
        final experienceId = (image['ExperienceID'] as num?)?.toInt();
        final imageUrl = image['ImageUrl'] as String? ?? '';
        if (experienceId != null) {
          experienceImageMap.putIfAbsent(experienceId, () => []).add(imageUrl);
        }
      }
    }

    if (data['experiences'] is List) {
      for (final item in data['experiences'] as List) {
        final experience = GuideExperience.fromJson(
          item as Map<String, dynamic>,
        );
        final imageUrls = experienceImageMap[experience.id] ?? [];
        experiences.add(
          GuideExperience(
            id: experience.id,
            title: experience.title,
            location: experience.location,
            date: experience.date,
            likes: experience.likes,
            isLiked: experience.isLiked,
            sortOrder: experience.sortOrder,
            imageUrls: imageUrls,
          ),
        );
      }
    }

    if (data['reviews'] is List) {
      reviewData.addAll(
        (data['reviews'] as List).map(
          (item) => GuideReview.fromJson(item as Map<String, dynamic>),
        ),
      );
    }

    return Guide.fromDetailJson(
      mergedGuideJson,
      languages: languages,
      pricing: pricing,
      experiences: experiences,
      reviewsData: reviewData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Guide>(
      future: _guideFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error loading guide: ${snapshot.error}')),
          );
        }

        final guide = snapshot.data ?? widget.guide;

        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: Colors.white,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Material(
                    color: Colors.black26,
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const Explore()),
                        );
                      },
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      _GuideImage(
                        imagePath: guide.backgroundImage,
                        fit: BoxFit.cover,
                      ),
                      Container(color: Colors.black.withOpacity(0.3)),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            image: DecorationImage(
                              image: _GuideImageProvider(
                                imagePath: guide.avatarImage.isNotEmpty
                                    ? guide.avatarImage
                                    : guide.image,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  guide.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    ...List.generate(
                                      5,
                                      (i) => Icon(
                                        i < guide.rating.round()
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: const Color(0xFFFFC107),
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${guide.reviews} Reviews',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const TripInformationScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00BFA5),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'CHOOSE THIS GUIDE',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: guide.languages
                            .map((lang) => _LanguageChip(label: lang))
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFF00BFA5),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            guide.location,
                            style: const TextStyle(
                              color: Color(0xFF00BFA5),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Short introduction:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        guide.description,
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _BackgroundThumbnail(
                        backgroundImage: guide.backgroundImage,
                        avatarImage: guide.avatarImage.isNotEmpty
                            ? guide.avatarImage
                            : guide.image,
                      ),
                      const SizedBox(height: 20),
                      _PricingTable(pricing: guide.pricing),
                      const SizedBox(height: 24),
                      MyExperiencesSection(experiences: guide.experiences),
                      const SizedBox(height: 24),
                      ReviewsSection(reviews: guide.reviewsData),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageChip extends StatelessWidget {
  final String label;
  const _LanguageChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}

class _BackgroundThumbnail extends StatelessWidget {
  final String backgroundImage;
  final String avatarImage;

  const _BackgroundThumbnail({
    required this.backgroundImage,
    required this.avatarImage,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 180,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _GuideImage(imagePath: backgroundImage, fit: BoxFit.cover),
            Container(color: Colors.black.withOpacity(0.3)),
            Center(
              child: Container(
                width: 94,
                height: 94,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.play_arrow, color: Colors.white, size: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideImage extends StatelessWidget {
  final String imagePath;
  final BoxFit fit;
  final Color fallbackColor;

  const _GuideImage({
    required this.imagePath,
    required this.fit,
    this.fallbackColor = const Color(0xFF90A4AE),
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return Container(color: fallbackColor);
    }

    return Image(
      image: _GuideImageProvider(imagePath: imagePath),
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          Container(color: fallbackColor),
    );
  }
}

ImageProvider _GuideImageProvider({required String imagePath}) {
  if (imagePath.startsWith('http')) {
    return NetworkImage(imagePath);
  }
  return AssetImage(imagePath);
}

class _PricingTable extends StatelessWidget {
  final List<GuidePricing>? pricing;

  const _PricingTable({this.pricing});

  @override
  Widget build(BuildContext context) {
    final rows = pricing != null && pricing!.isNotEmpty
        ? pricing!
              .map(
                (price) => {
                  'group': price.groupLabel,
                  'price':
                      '${price.currency.isNotEmpty ? price.currency : '\$'}${price.price.toStringAsFixed(2)}',
                },
              )
              .toList()
        : [
            {'group': '1 - 3 Travelers', 'price': '\$10/ hour'},
            {'group': '4 - 6 Travelers', 'price': '\$14/ hour'},
            {'group': '7 - 9 Travelers', 'price': '\$17/ hour'},
          ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final i = entry.key;
          final row = entry.value;
          final isLast = i == rows.length - 1;
          return Container(
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  row['group']!,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                Text(
                  row['price']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
