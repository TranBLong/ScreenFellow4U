import 'package:flutter/material.dart';

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  static const _reviews = [
    _Review(
      name: 'Pena Valdez',
      date: 'Jan 22, 2020',
      rating: 4,
      comment:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
          "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
          'when an unknown printer took a galley of type and scrambled it to make a type '
          'specimen book. It has survived not only five centuries.',
      avatarUrl: 'assets/images/chooseaguide/main/reviews/Ellipse 11.png',
    ),
    _Review(
      name: 'Daehyun',
      date: 'Jan 22, 2020',
      rating: 4,
      comment:
          'Many desktop publishing packages and web page editors now use Lorem Ipsum as '
          "their default model text, and a search for 'lorem ipsum'",
      avatarUrl: 'assets/images/chooseaguide/main/reviews/Ellipse 11 (1).png',
    ),
    _Review(
      name: 'Burns Marks',
      date: 'Jan 22, 2020',
      rating: 4,
      comment:
          'There are many variations of passages of Lorem Ipsum available, but the majority '
          'have suffered alteration in some form, by injected humour, or randomised words '
          "which don't look even slightly believable.",
      avatarUrl: 'assets/images/chooseaguide/main/reviews/Ellipse 11 (2).png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Reviews',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'SEE MORE',
                style: TextStyle(
                  color: Color(0xFF00BFA5),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _reviews.length,
          separatorBuilder: (_, __) =>
              const Divider(height: 28, thickness: 0.8),
          itemBuilder: (_, i) => _ReviewItem(review: _reviews[i]),
        ),
      ],
    );
  }
}

class _Review {
  final String name;
  final String date;
  final double rating;
  final String comment;
  final String avatarUrl;

  const _Review({
    required this.name,
    required this.date,
    required this.rating,
    required this.comment,
    required this.avatarUrl,
  });
}

class _ReviewItem extends StatelessWidget {
  final _Review review;
  const _ReviewItem({required this.review});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: review.avatarUrl.startsWith('http')
                  ? NetworkImage(review.avatarUrl)
                  : AssetImage(review.avatarUrl) as ImageProvider,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _StarRating(rating: review.rating),
                      const SizedBox(width: 10),
                      Text(
                        review.date,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          review.comment,
          style: const TextStyle(
            fontSize: 13.5,
            color: Colors.black87,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}

class _StarRating extends StatelessWidget {
  final double rating;
  final int maxStars;
  final double size;

  const _StarRating({required this.rating, this.maxStars = 5, this.size = 15});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (i) {
        final filled = i < rating.floor();
        final half = !filled && (i < rating);
        return Icon(
          half ? Icons.star_half : (filled ? Icons.star : Icons.star_border),
          color: const Color(0xFFFFC107),
          size: size,
        );
      }),
    );
  }
}
