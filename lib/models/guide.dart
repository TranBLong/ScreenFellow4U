class Guide {
  final String name;
  final String location;
  final String image;
  final int rating;
  final int reviews;
  final List<String> languages;
  final String description;

  Guide({
    required this.name,
    required this.location,
    required this.image,
    this.rating = 5,
    this.reviews = 0,
    this.languages = const ['Vietnamese', 'English'],
    this.description = 'Short introduction about the guide...',
  });
}
