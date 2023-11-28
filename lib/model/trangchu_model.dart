
class Manga {
  final String id;
  final String mangaName;
  final String image;
  final String category;
  final int totalChapters;
  final String author;
  final int view;

  Manga({
    required this.id,
    required this.mangaName,
    required this.image,
    required this.category,
    required this.totalChapters,
    required this.author,
    required this.view

  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      id: json['id'],
      mangaName: json['manganame'],
      image: json['image'],
      category: json['category'],
      author: json['author'],
      totalChapters: json['totalChapters'],
      view: json['view']
    );
  }

}
