class Tour {
  final int? id;
  final String title;
  final String description;
  final String location;
  final double price;
  final double originalPrice;
  final String duration;
  final String departureDate;
  final String departurePlace;
  final String itinerary;
  final String providerName;
  final double rating;
  final int totalLikes;
  final int totalReviews;
  final String coverImageUrl;
  final bool isFavorite;
  final bool isBookmarked;
  final List<String> images;
  final List<TourSchedule> schedules;
  final List<TourPricing> pricing;
  final List<TourReview> reviews;

  Tour({
    this.id,
    required this.title,
    required this.description,
    required this.location,
    this.price = 0.0,
    this.originalPrice = 0.0,
    this.duration = '',
    this.departureDate = '',
    this.departurePlace = '',
    this.itinerary = '',
    this.providerName = '',
    this.rating = 0.0,
    this.totalLikes = 0,
    this.totalReviews = 0,
    this.coverImageUrl = '',
    this.isFavorite = false,
    this.isBookmarked = false,
    this.images = const [],
    this.schedules = const [],
    this.pricing = const [],
    this.reviews = const [],
  });

  factory Tour.fromJson(Map<String, dynamic> json) {
    final tourJson = json['tour'] as Map<String, dynamic>? ?? json;
    return Tour(
      id: _readInt(tourJson, const ['TourID', 'id', 'ID']),
      title: _readString(tourJson, const ['Title', 'title', 'Name', 'name']),
      description: _readString(tourJson, const ['Description', 'description']),
      location: _readString(tourJson, const ['Location', 'location']),
      price: _readDouble(tourJson, const ['Price', 'price']) ?? 0.0,
      originalPrice: _readDouble(tourJson, const ['OriginalPrice', 'originalPrice']) ?? 0.0,
      duration: _readString(tourJson, const ['Duration', 'duration']),
      departureDate: _readString(tourJson, const ['DepartureDate', 'departureDate']),
      departurePlace: _readString(tourJson, const ['DeparturePlace', 'departurePlace']),
      itinerary: _readString(tourJson, const ['Itinerary', 'itinerary']),
      providerName: _readString(tourJson, const ['ProviderName', 'providerName']),
      rating: _readDouble(tourJson, const ['Rating', 'rating']) ?? 0.0,
      totalLikes: _readInt(tourJson, const ['TotalLikes', 'totalLikes']) ?? 0,
      totalReviews: _readInt(tourJson, const ['TotalReviews', 'totalReviews']) ?? 0,
      coverImageUrl: _readString(tourJson, const ['CoverImageUrl', 'coverImageUrl', 'ImageUrl', 'imageUrl']),
      isFavorite: _readBool(tourJson, const ['IsFavorite', 'isFavorite']),
      isBookmarked: _readBool(tourJson, const ['IsBookmarked', 'isBookmarked']),
      images: _readStringList(json['images'] ?? tourJson['images']),
      schedules: _readScheduleList(json['schedules'] ?? tourJson['schedules']),
      pricing: _readPricingList(json['pricing'] ?? tourJson['pricing']),
      reviews: _readReviewList(json['reviews'] ?? tourJson['reviews']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'price': price,
      'originalPrice': originalPrice,
      'duration': duration,
      'departureDate': departureDate,
      'departurePlace': departurePlace,
      'itinerary': itinerary,
      'providerName': providerName,
      'rating': rating,
      'totalLikes': totalLikes,
      'totalReviews': totalReviews,
      'coverImageUrl': coverImageUrl,
      'isFavorite': isFavorite,
      'isBookmarked': isBookmarked,
      'images': images,
      'schedules': schedules.map((item) => item.toJson()).toList(),
      'pricing': pricing.map((item) => item.toJson()).toList(),
      'reviews': reviews.map((item) => item.toJson()).toList(),
    };
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

  static bool _readBool(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value == null) continue;
      if (value is bool) return value;
      final string = value.toString().toLowerCase();
      if (string == '1' || string == 'true' || string == 'yes') return true;
      if (string == '0' || string == 'false' || string == 'no') return false;
    }
    return false;
  }

  static List<String> _readStringList(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item?.toString() ?? '')
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return const [];
  }

  static List<TourSchedule> _readScheduleList(dynamic value) {
    if (value is List) {
      return value.map((item) {
        return TourSchedule.fromJson(item as Map<String, dynamic>);
      }).toList();
    }
    return const [];
  }

  static List<TourPricing> _readPricingList(dynamic value) {
    if (value is List) {
      return value.map((item) {
        return TourPricing.fromJson(item as Map<String, dynamic>);
      }).toList();
    }
    return const [];
  }

  static List<TourReview> _readReviewList(dynamic value) {
    if (value is List) {
      return value.map((item) {
        return TourReview.fromJson(item as Map<String, dynamic>);
      }).toList();
    }
    return const [];
  }
}

class TourSchedule {
  final int? id;
  final int dayNumber;
  final String routeLabel;
  final List<TourScheduleItem> items;

  TourSchedule({
    this.id,
    this.dayNumber = 0,
    this.routeLabel = '',
    this.items = const [],
  });

  factory TourSchedule.fromJson(Map<String, dynamic> json) {
    return TourSchedule(
      id: Tour._readInt(json, const ['ScheduleID', 'id']),
      dayNumber: Tour._readInt(json, const ['DayNumber', 'dayNumber']) ?? 0,
      routeLabel: Tour._readString(json, const ['RouteLabel', 'routeLabel']),
      items: _readItems(json['items'] ?? json['Items']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayNumber': dayNumber,
      'routeLabel': routeLabel,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  static List<TourScheduleItem> _readItems(dynamic value) {
    if (value is List) {
      return value.map((item) {
        return TourScheduleItem.fromJson(item as Map<String, dynamic>);
      }).toList();
    }
    return const [];
  }
}

class TourScheduleItem {
  final int? id;
  final String timeSlot;
  final String description;

  TourScheduleItem({
    this.id,
    this.timeSlot = '',
    this.description = '',
  });

  factory TourScheduleItem.fromJson(Map<String, dynamic> json) {
    return TourScheduleItem(
      id: Tour._readInt(json, const ['ItemID', 'id']),
      timeSlot: Tour._readString(json, const ['TimeSlot', 'timeSlot']),
      description: Tour._readString(json, const ['Description', 'description']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timeSlot': timeSlot,
      'description': description,
    };
  }
}

class TourPricing {
  final int? id;
  final String label;
  final double price;
  final bool isFree;

  TourPricing({
    this.id,
    required this.label,
    this.price = 0.0,
    this.isFree = false,
  });

  factory TourPricing.fromJson(Map<String, dynamic> json) {
    return TourPricing(
      id: Tour._readInt(json, const ['PricingID', 'PricingId', 'id']),
      label: Tour._readString(json, const ['Label', 'label']),
      price: Tour._readDouble(json, const ['Price', 'price']) ?? 0.0,
      isFree: Tour._readBool(json, const ['IsFree', 'isFree']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'price': price,
      'isFree': isFree,
    };
  }
}

class TourReview {
  final int? id;
  final int? userId;
  final String userName;
  final String avatarUrl;
  final double rating;
  final String comment;
  final String date;

  TourReview({
    this.id,
    this.userId,
    this.userName = '',
    this.avatarUrl = '',
    this.rating = 0.0,
    this.comment = '',
    this.date = '',
  });

  factory TourReview.fromJson(Map<String, dynamic> json) {
    return TourReview(
      id: Tour._readInt(json, const ['ReviewID', 'id']),
      userId: Tour._readInt(json, const ['UserID', 'userId']),
      userName: Tour._readString(json, const ['FullName', 'fullName', 'Name', 'name']),
      avatarUrl: Tour._readString(json, const ['Avatar', 'avatar', 'AvatarUrl', 'avatarUrl']),
      rating: Tour._readDouble(json, const ['Rating', 'rating']) ?? 0.0,
      comment: Tour._readString(json, const ['Comment', 'comment']),
      date: Tour._readString(json, const ['Date', 'date', 'CreatedAt', 'createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'avatarUrl': avatarUrl,
      'rating': rating,
      'comment': comment,
      'date': date,
    };
  }
}
