class MangaDetailModel {
  final String mangaName;
  final String author;
  final String content;
  final String image;
  final String category;
  final int view;
  final int like;
  final int totalChapters;
  final List<Chapter> chapters;

  final bool isLiked;


  MangaDetailModel({
    required this.mangaName,
    required this.author,
    required this.content,
    required this.image,
    required this.category,
    required this.view,
    required this.like,
    required this.totalChapters,
    required this.chapters,
    required this.isLiked,
  });

  factory MangaDetailModel.fromJson(Map<String, dynamic> json) {
    List<Chapter> chapterList = (json['chapters'] as List).map((chapterJson) {
      return Chapter.fromJson(chapterJson);
    }).toList();
   
    return MangaDetailModel(
      mangaName: json['manganame'],
      author: json['author'],
      content: json['content'],
      image: json['image'],
      category: json['category'],
      view: json['view'],
      like: json['like'],
      totalChapters: json['totalChapters'],
      chapters: chapterList,
      isLiked: json['isLiked']
   
    );
  }
}

class Chapter {
  final String idchap;
  final String namechap;
  final String viporfree;

  Chapter({
    required this.idchap,
    required this.namechap,
    required this.viporfree,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      idchap: json['idchap'],
      namechap: json['namechap'],
      viporfree: json['viporfree'],
    );
  }
}
