import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/travel_news.dart';

class TravelNewsService {
  // Sử dụng Node.js backend
  static const String baseUrl = 'http://192.168.100.6:5000'; // Thay đổi theo IP máy tính của bạn

  static Future<List<TravelNews>> fetchTravelNews() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/travel-news'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return (data['data'] as List).map((item) => TravelNews.fromJson(item)).toList();
        } else {
          throw Exception('Failed to load data');
        }
      } else {
        throw Exception('Failed to load travel news');
      }
    } catch (e) {
      throw Exception('Error fetching travel news: $e');
    }
  }
}