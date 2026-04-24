import 'package:flutter/material.dart';
import 'package:ktck/api_service.dart';
import 'package:ktck/chooseaguide/guidepage/mainguidepage.dart';
import 'package:ktck/models/guide.dart';
import 'package:ktck/seemore/guidesmore.dart';

class BestGuidesWidget extends StatefulWidget {
  const BestGuidesWidget({super.key});

  @override
  State<BestGuidesWidget> createState() => _BestGuidesWidgetState();
}

class _BestGuidesWidgetState extends State<BestGuidesWidget> {
  late final Future<List<Guide>> _guidesFuture;

  @override
  void initState() {
    super.initState();
    _guidesFuture = _fetchFeaturedGuides();
  }

  Future<List<Guide>> _fetchFeaturedGuides() async {
    final response = await ApiService.getFeaturedGuides();
    final success = response['success'];
    final isSuccess = success == true || success == 1 || success == 'true';
    if (!isSuccess) {
      return [];
    }

    final rawItems = _extractGuideItems(response);
    return rawItems
        .whereType<Map<String, dynamic>>()
        .map(Guide.fromSummaryJson)
        .toList();
  }

  List<Map<String, dynamic>> _extractGuideItems(Map<String, dynamic> response) {
    final candidates = [
      response['data'],
      response['guides'],
      response['featuredGuides'],
      response['items'],
      response['result'],
    ];

    for (final candidate in candidates) {
      if (candidate is List) {
        return candidate
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item.cast<String, dynamic>()))
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Best Guides',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GuidesMoreScreen()),
                );
              },
              child: const Text(
                'SEE MORE',
                style: TextStyle(
                  color: Color(0xFF00CEA6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<Guide>>(
          future: _guidesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 28),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Text('Failed to load guides: ${snapshot.error}'),
              );
            }

            final guides = snapshot.data ?? const <Guide>[];
            if (guides.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 28),
                child: Text('No guides available right now.'),
              );
            }

            return GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: guides
                  .map((guide) => _buildGuideCard(context: context, guide: guide))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGuideCard({
    required BuildContext context,
    required Guide guide,
  }) {
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
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: _GuideCardImage(imagePath: imagePath),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                index < guide.rating.round() ? Icons.star : Icons.star_border,
                color: Colors.orange,
                size: 14,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            guide.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: Color(0xFF00CEA6)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  guide.location,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF00CEA6)),
                  maxLines: 1,
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

    final widget = imagePath.startsWith('http')
        ? Image.network(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (_, __, ___) => _fallback(),
          )
        : Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (_, __, ___) => _fallback(),
          );

    return widget;
  }

  Widget _fallback() {
    return Container(
      color: Colors.grey[300],
      alignment: Alignment.center,
      child: const Icon(Icons.person, size: 50, color: Colors.white),
    );
  }
}
