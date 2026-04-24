import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Thay thế bằng địa chỉ IP máy tính của bạn
  static const String baseUrl = 'http://192.168.100.6:5000';
  // static const String baseUrl = 'http://10.105.24.216:5000';

  // ==================== AUTH ====================
  static Future<List<dynamic>> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/test_connection.php'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String role,
    String? country,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'role': role,
          'country': country ?? '',
        }),
      );

      return json.decode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      return json.decode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  // ==================== TOUR APIS ====================

  // GET all tours with pagination
  static Future<Map<String, dynamic>> getAllTours({
    int page = 1,
    int limit = 10,
    String search = '',
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tours?page=$page&limit=$limit&search=$search'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load tours');
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // GET tour by ID with all details
  static Future<Map<String, dynamic>> getTourById(int tourId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tours/$tourId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load tour details');
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // GET featured tours
  static Future<Map<String, dynamic>> getFeaturedTours({int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tours/featured?limit=$limit'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load featured tours');
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // GET top-rated tours
  static Future<Map<String, dynamic>> getTopRatedTours({int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tours/top-rated?limit=$limit'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load top-rated tours');
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // GET all guides with pagination and optional filters
  static Future<Map<String, dynamic>> getAllGuides({
    int page = 1,
    int limit = 10,
    String search = '',
    String location = '',
    String language = '',
  }) async {
    try {
      String url = '$baseUrl/api/guides?page=$page&limit=$limit';
      if (search.isNotEmpty) url += '&search=$search';
      if (location.isNotEmpty) url += '&location=$location';
      if (language.isNotEmpty) url += '&language=$language';

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load guides');
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // GET guide details by ID
  static Future<Map<String, dynamic>> getGuideById(int guideId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/guides/$guideId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load guide details');
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // GET featured guides
  static Future<Map<String, dynamic>> getFeaturedGuides({int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/guides/featured?limit=$limit'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load featured guides');
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // GET top-rated guides
  static Future<Map<String, dynamic>> getTopRatedGuides({int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/guides/top-rated?limit=$limit'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load top-rated guides');
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Search tours with filters
  static Future<Map<String, dynamic>> searchTours({
    String keyword = '',
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? departure,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      String url = '$baseUrl/api/tours/search?page=$page&limit=$limit';
      if (keyword.isNotEmpty) url += '&keyword=$keyword';
      if (minPrice != null) url += '&minPrice=$minPrice';
      if (maxPrice != null) url += '&maxPrice=$maxPrice';
      if (minRating != null) url += '&minRating=$minRating';
      if (departure != null && departure.isNotEmpty)
        url += '&departure=$departure';

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to search tours');
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // GET tour reviews
  static Future<Map<String, dynamic>> getTourReviews(
    int tourId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tours/$tourId/reviews?page=$page&limit=$limit'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // POST bookmark tour
  static Future<Map<String, dynamic>> bookmarkTour(
    int tourId,
    int userId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/tours/$tourId/bookmark'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // DELETE bookmark tour
  static Future<Map<String, dynamic>> removeBookmark(
    int tourId,
    int userId,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/tours/$tourId/bookmark'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // GET user bookmarks
  static Future<Map<String, dynamic>> getUserBookmarks(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tours/user/bookmarks'),
        headers: {
          'Content-Type': 'application/json',
          'user-id': userId.toString(),
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load bookmarks');
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // POST like tour
  static Future<Map<String, dynamic>> likeTour(int tourId, int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/tours/$tourId/like'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // POST unlike tour
  static Future<Map<String, dynamic>> unlikeTour(int tourId, int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/tours/$tourId/unlike'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // POST review
  static Future<Map<String, dynamic>> postReview(
    int tourId, {
    required int userId,
    required double rating,
    String? comment,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/tours/$tourId/review'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'rating': rating,
          'comment': comment ?? '',
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
