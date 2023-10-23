
class Manga {
  final String id;
  final String mangaName;
  final String image;
  final String category;
  final int totalChapters;

  Manga({
    required this.id,
    required this.mangaName,
    required this.image,
    required this.category,
    required this.totalChapters,
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      id: json['id'],
      mangaName: json['manganame'],
      image: json['image'],
      category: json['category'],
      
      totalChapters: json['totalChapters'],
    );
  }

}
