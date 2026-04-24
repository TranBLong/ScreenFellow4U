import 'package:flutter/material.dart';
import 'package:ktck/models/guide.dart';

class MyExperiencesSection extends StatelessWidget {
  final List<GuideExperience>? experiences;

  const MyExperiencesSection({super.key, this.experiences});

  static const _experiences = [
    _Experience(
      title: '2 Hour Bicycle Tour exploring Hoian',
      location: 'Hoian, Vietnam',
      date: 'Jan 25, 2020',
      likes: 1234,
      imageLeft: 'assets/images/chooseaguide/main/nhom1/hoian 1 (2).png',
      imageTopRight: 'assets/images/chooseaguide/main/nhom1/hoianvietnam 1.png',
      imageBottomRight:
          'assets/images/chooseaguide/main/nhom1/da-nang-to-hoi-an 1.png',
    ),
    _Experience(
      title: 'Food tour in Danang',
      location: 'Danang, Vietnam',
      date: 'Jan 20, 2020',
      likes: 234,
      imageLeft:
          'assets/images/chooseaguide/main/nhom2/24857474954_0b3a85f7a6_b 1.png',
      imageTopRight:
          'assets/images/chooseaguide/main/nhom2/DSCF0605-001-1-1300x867 1.png',
      imageBottomRight:
          'assets/images/chooseaguide/main/nhom2/20140826-danang-vietnam-pho753-brian-oh 1.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final displayExperiences = experiences != null && experiences!.isNotEmpty
        ? experiences!.map((exp) => _Experience.fromGuideExperience(exp)).toList()
        : _experiences;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Experiences',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...displayExperiences
            .map(
              (exp) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ExperienceCard(experience: exp),
              ),
            )
            .toList(),
      ],
    );
  }
}

class _Experience {
  final String title;
  final String location;
  final String date;
  final int likes;
  final String imageLeft;
  final String imageTopRight;
  final String imageBottomRight;

  const _Experience({
    required this.title,
    required this.location,
    required this.date,
    required this.likes,
    required this.imageLeft,
    required this.imageTopRight,
    required this.imageBottomRight,
  });

  factory _Experience.fromGuideExperience(GuideExperience experience) {
    final images = experience.imageUrls;
    const fallback = 'assets/images/chooseaguide/main/nhom1/hoian 1 (2).png';
    return _Experience(
      title: experience.title,
      location: experience.location,
      date: experience.date.isNotEmpty ? experience.date : 'Unknown date',
      likes: experience.likes,
      imageLeft: images.isNotEmpty ? images[0] : fallback,
      imageTopRight: images.length > 1 ? images[1] : fallback,
      imageBottomRight: images.length > 2 ? images[2] : fallback,
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  final _Experience experience;
  const _ExperienceCard({required this.experience});

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    final exp = widget.experience;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ThreeImageGrid(
            imageLeft: exp.imageLeft,
            imageTopRight: exp.imageTopRight,
            imageBottomRight: exp.imageBottomRight,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exp.title,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF00BFA5),
                      size: 15,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      exp.location,
                      style: const TextStyle(
                        color: Color(0xFF00BFA5),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      exp.date,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _liked = !_liked),
                      child: Row(
                        children: [
                          Icon(
                            _liked ? Icons.favorite : Icons.favorite_border,
                            color: _liked ? Colors.redAccent : Colors.grey,
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${_liked ? exp.likes + 1 : exp.likes} Likes',
                            style: TextStyle(
                              fontSize: 13,
                              color: _liked ? Colors.redAccent : Colors.grey,
                            ),
                          ),
                        ],
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

class _ThreeImageGrid extends StatelessWidget {
  final String imageLeft;
  final String imageTopRight;
  final String imageBottomRight;

  const _ThreeImageGrid({
    required this.imageLeft,
    required this.imageTopRight,
    required this.imageBottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Row(
        children: [
          Expanded(flex: 6, child: _NetImage(url: imageLeft)),
          const SizedBox(width: 2),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Expanded(child: _NetImage(url: imageTopRight)),
                const SizedBox(height: 2),
                Expanded(child: _NetImage(url: imageBottomRight)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NetImage extends StatelessWidget {
  final String url;
  const _NetImage({required this.url});

  @override
  Widget build(BuildContext context) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    return Image.asset(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
