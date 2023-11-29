class Bangtin {
  String id;
  String userId;
  String username;
  String? content;
  int like;
  String? date;
  bool isLiked;
  int cmt;
  List<Comment>? comments;
  List<String>? images;

  Bangtin({
    required this.id,
    required this.userId,
    required this.username,
    this.content,
    required this.like,
    required this.isLiked,
    this.date,
    this.comments,
    required this.cmt,
    this.images,
  });

  factory Bangtin.fromJson(Map<String, dynamic> json) {
    List<Comment>? comments = [];
    if (json['comment'] != null) {
      comments = List<Comment>.from(
        json['comment'].map((commentJson) => Comment.fromJson(commentJson)),
      );
    }

    return Bangtin(
      id: json['_id'],
      userId: json['userId'],
      username: json['username'],
      content: json['content'],
      like: json['like'],
      isLiked: json['isLiked'],
      date: json['date'],
      comments: comments,
      cmt: json['commentCount'],
      images:
          (json['images'] != null) ? List<String>.from(json['images']) : null,
    );
  }
}

class Comment {
  String? id;
  String? userId;
  String? username;
  String? content;
  String? date;

  Comment({
    this.id,
    this.userId,
    this.username,
    this.content,
    this.date,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      userId: json['userId'],
      content: json['cmt'],
      username: json['username'],
      date: json['date'],
    );
  }
}
