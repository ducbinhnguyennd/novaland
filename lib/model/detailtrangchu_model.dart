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
  final List<Comments> cmts;

   bool? isLiked;


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
    required this.cmts,
     this.isLiked,
  });

  factory MangaDetailModel.fromJson(Map<String, dynamic> json) {
    List<Chapter> chapterList = (json['chapters'] as List).map((chapterJson) {
      return Chapter.fromJson(chapterJson);
    }).toList();
   List<Comments> cmtList = (json['comments'] as List).map((cmtJson) {
      return Comments.fromJson(cmtJson);
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
      cmts: cmtList,
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
class Comments {
  final String idcmt;
  final String usernamecmt;
  final String noidung;

  Comments({
    required this.idcmt,
    required this.usernamecmt,
    required this.noidung,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      idcmt: json['userID'],
      usernamecmt: json['username'],
      noidung: json['cmt'],
    );
  }
}
