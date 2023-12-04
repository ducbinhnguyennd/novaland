import 'package:loginapp/model/trangchu_model.dart';

class NhomdichModel {
  final String userId;
  final String username;
  final String avatar;
  final bool isFollow;
  final int followNumber;
  final List<Manga> manga;

  NhomdichModel({
    required this.userId,
    required this.username,
    required this.avatar,
    required this.isFollow,
    required this.followNumber,
    required this.manga,
  });

  factory NhomdichModel.fromJson(Map<String, dynamic> json) {
    List<Manga> mangaList = (json['manga'] as List)
        .map((mangaJson) => Manga.fromJson(mangaJson))
        .toList();

    return NhomdichModel(
      userId: json['userId'],
      username: json['username'],
      avatar: json['avatar'],
      isFollow: json['isfollow'],
      followNumber: json['follownumber'],
      manga: mangaList,
    );
  }
}
