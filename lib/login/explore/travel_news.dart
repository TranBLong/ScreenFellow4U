import 'package:flutter/material.dart';
import '../../travelnew/travelnewdetail.dart';
import '../../models/travel_news.dart';
import '../../travel_news_service.dart';
import '../../seemore/travelnewmore.dart';

class TravelNewsWidget extends StatefulWidget {
  const TravelNewsWidget({super.key});

  @override
  State<TravelNewsWidget> createState() => _TravelNewsWidgetState();
}

class _TravelNewsWidgetState extends State<TravelNewsWidget> {
  List<TravelNews> _news = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadTravelNews();
  }

  Future<void> _loadTravelNews() async {
    try {
      final news = await TravelNewsService.fetchTravelNews();
      setState(() {
        _news = news;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Travel News",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TravelNewMoreScreen(),
                    ),
                  );
                },
                child: const Text(
                  "SEE MORE",
                  style: TextStyle(
                    color: Color(0xFF00CEA6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error.isNotEmpty)
            Center(child: Text('Error: $_error'))
          else
            ..._news.take(3).map((news) => Column(
              children: [
                _buildNewsItem(
                  title: news.title,
                  date: _formatDate(news.publishDate),
                  image: news.imageUrl,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TravelNewsDetailScreen(
                          title: news.title,
                          date: _formatDate(news.publishDate),
                          image: news.imageUrl,
                          content: news.content ?? '',
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            )),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.month}/${date.day}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildNewsItem({
    required String title,
    required String date,
    required String image,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(date, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            image,
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        ],
      ),
    );
  }
}
