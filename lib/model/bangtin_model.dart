class Bangtin {
  String id;
  String userId;
  String username;
  String content;
  int like;
  String date;
  bool isLiked;
  int cmt;
  List<Comment>? comments;

  Bangtin(
      {required this.id,
      required this.userId,
      required this.username,
      required this.content,
      required this.like,
      required this.isLiked,
      required this.date,
      this.comments,
      required this.cmt});

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
        cmt: json['commentCount']);
  }
}

class Comment {
  String? id;
  String? userId;
  String? username;
  String? content;

  Comment({
    this.id,
    this.userId,
    this.username,
    this.content,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      userId: json['userId'],
      username: json['username'],
      content: json['cmt'],
    );
  }
}
