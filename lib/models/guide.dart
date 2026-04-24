class Guide {
  final int? id;
  final String name;
  final String location;
  final String image;
  final String avatarImage;
  final String backgroundImage;
  final double rating;
  final int reviews;
  final int totalLikes;
  final String description;
  final List<String> languages;
  final List<GuidePricing> pricing;
  final List<GuideExperience> experiences;
  final List<GuideReview> reviewsData;

  Guide({
    this.id,
    required this.name,
    required this.location,
    required this.image,
    this.avatarImage = '',
    this.backgroundImage = '',
    this.rating = 5.0,
    this.reviews = 0,
    this.totalLikes = 0,
    this.description = 'Short introduction about the guide...',
    this.languages = const ['Vietnamese', 'English'],
    this.pricing = const [],
    this.experiences = const [],
    this.reviewsData = const [],
  });

  factory Guide.fromSummaryJson(Map<String, dynamic> json) {
    return Guide(
      id: _readInt(json, const ['GuideID', 'GuideId', 'id']),
      name: _readString(json, const ['Name', 'name', 'GuideName', 'guideName']),
      location: _readString(json, const [
        'Location',
        'location',
        'GuideLocation',
        'guideLocation',
      ]),
      image: _readString(json, const [
        'Image',
        'image',
        'ImageUrl',
        'imageUrl',
        'Avatar',
        'avatar',
        'AvatarUrl',
        'avatarUrl',
        'AvatarImage',
        'avatarImage',
      ]),
      avatarImage: _readString(json, const [
        'Avatar',
        'AvatarUrl',
        'AvatarImage',
        'AvatarImageUrl',
        'avatar',
        'avatarUrl',
        'avatarImage',
      ]),
      backgroundImage: _readString(json, const [
        'Background',
        'BackgroundUrl',
        'BackgroundImage',
        'BackgroundImageUrl',
        'background',
        'backgroundUrl',
        'backgroundImage',
      ]),
      description: _readString(json, const ['Description', 'description']),
      reviews: _readInt(json, const ['Reviews', 'reviews']) ?? 0,
      rating: _readDouble(json, const ['Rating', 'rating']) ?? 0.0,
      totalLikes: _readInt(json, const ['TotalLikes', 'totalLikes']) ?? 0,
    );
  }

  factory Guide.fromDetailJson(
    Map<String, dynamic> json, {
    List<String>? languages,
    List<GuidePricing>? pricing,
    List<GuideExperience>? experiences,
    List<GuideReview>? reviewsData,
  }) {
    return Guide(
      id: _readInt(json, const ['GuideID', 'GuideId', 'id']),
      name: _readString(json, const ['Name', 'name', 'GuideName', 'guideName']),
      location: _readString(json, const [
        'Location',
        'location',
        'GuideLocation',
        'guideLocation',
      ]),
      image: _readString(json, const [
        'Image',
        'image',
        'ImageUrl',
        'imageUrl',
        'Avatar',
        'avatar',
        'AvatarUrl',
        'avatarUrl',
        'AvatarImage',
        'avatarImage',
      ]),
      avatarImage: _readString(json, const [
        'Avatar',
        'AvatarUrl',
        'AvatarImage',
        'AvatarImageUrl',
        'avatar',
        'avatarUrl',
        'avatarImage',
      ]),
      backgroundImage: _readString(json, const [
        'Background',
        'BackgroundUrl',
        'BackgroundImage',
        'BackgroundImageUrl',
        'background',
        'backgroundUrl',
        'backgroundImage',
      ]),
      description: _readString(json, const ['Description', 'description']),
      reviews: _readInt(json, const ['Reviews', 'reviews']) ?? 0,
      rating: _readDouble(json, const ['Rating', 'rating']) ?? 0.0,
      totalLikes: _readInt(json, const ['TotalLikes', 'totalLikes']) ?? 0,
      languages: languages ?? const ['Vietnamese', 'English'],
      pricing: pricing ?? const [],
      experiences: experiences ?? const [],
      reviewsData: reviewsData ?? const [],
    );
  }

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    return '';
  }

  static int? _readInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value == null) continue;
      final parsed = int.tryParse(value.toString());
      if (parsed != null) return parsed;
    }
    return null;
  }

  static double? _readDouble(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value == null) continue;
      final parsed = double.tryParse(value.toString());
      if (parsed != null) return parsed;
    }
    return null;
  }
}

class GuidePricing {
  final int? id;
  final String groupLabel;
  final double price;
  final String currency;

  GuidePricing({
    this.id,
    required this.groupLabel,
    required this.price,
    required this.currency,
  });

  factory GuidePricing.fromJson(Map<String, dynamic> json) {
    return GuidePricing(
      id: Guide._readInt(json, const ['PricingID', 'PricingId', 'id']),
      groupLabel: Guide._readString(json, const [
        'GroupLabel',
        'groupLabel',
        'Group',
        'group',
      ]),
      price: Guide._readDouble(json, const ['Price', 'price']) ?? 0.0,
      currency: Guide._readString(json, const ['Currency', 'currency']),
    );
  }
}

class GuideExperience {
  final int? id;
  final String title;
  final String location;
  final String date;
  final int likes;
  final bool isLiked;
  final int sortOrder;
  final List<String> imageUrls;

  GuideExperience({
    this.id,
    required this.title,
    required this.location,
    required this.date,
    this.likes = 0,
    this.isLiked = false,
    this.sortOrder = 0,
    this.imageUrls = const [],
  });

  factory GuideExperience.fromJson(Map<String, dynamic> json) {
    return GuideExperience(
      id: Guide._readInt(json, const ['ExperienceID', 'ExperienceId', 'id']),
      title: Guide._readString(json, const ['Title', 'title']),
      location: Guide._readString(json, const ['Location', 'location']),
      date: json['Date']?.toString() ?? '',
      likes: Guide._readInt(json, const ['Likes', 'likes']) ?? 0,
      isLiked: json['IsLiked'] == 1 || json['IsLiked'] == true,
      sortOrder: Guide._readInt(json, const ['SortOrder', 'sortOrder']) ?? 0,
    );
  }
}

class GuideReview {
  final int? id;
  final String name;
  final String date;
  final double rating;
  final String comment;
  final String avatarUrl;

  GuideReview({
    this.id,
    required this.name,
    required this.date,
    required this.rating,
    required this.comment,
    required this.avatarUrl,
  });

  factory GuideReview.fromJson(Map<String, dynamic> json) {
    return GuideReview(
      id: Guide._readInt(json, const ['ReviewID', 'ReviewId', 'id']),
      name: Guide._readString(json, const ['Name', 'name']),
      date: json['Date']?.toString() ?? '',
      rating: Guide._readDouble(json, const ['Rating', 'rating']) ?? 0.0,
      comment: Guide._readString(json, const ['Comment', 'comment']),
      avatarUrl: Guide._readString(json, const [
        'AvatarUrl',
        'Avatar',
        'avatarUrl',
        'avatar',
      ]),
    );
  }
}
