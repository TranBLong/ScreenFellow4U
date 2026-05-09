class TravelNews {
  final int id;
  final String title;
  final String publishDate;
  final String imageUrl;
  final String summary;
  final int viewCount;
  final bool isFeatured;
  final String createdAt;
  final String? content;
  final String? author;
  final String? tags;

  TravelNews({
    required this.id,
    required this.title,
    required this.publishDate,
    required this.imageUrl,
    required this.summary,
    required this.viewCount,
    required this.isFeatured,
    required this.createdAt,
    this.content,
    this.author,
    this.tags,
  });

  factory TravelNews.fromJson(Map<String, dynamic> json) {
    return TravelNews(
      id: json['id'],
      title: json['title'],
      publishDate: json['publish_date'],
      imageUrl: json['image_url'],
      summary: json['summary'],
      viewCount: json['view_count'],
      isFeatured: json['is_featured'] == 1,
      createdAt: json['created_at'],
      content: json['content'],
      author: json['author'],
      tags: json['tags'],
    );
  }
}