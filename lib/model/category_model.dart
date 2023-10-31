import 'package:loginapp/model/trangchu_model.dart';

class CategoryModel {
  final String id;
  final String categoryName;
  final List<Manga> mangaList;

  CategoryModel({required this.id, required this.categoryName, required this.mangaList});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> mangaDataList = json['manga'] ?? [];
    final List<Manga> mangaList = mangaDataList
        .map((mangaData) => Manga.fromJson(mangaData))
        .toList();
    return CategoryModel(
      id: json['categoryid'],
      categoryName: json['categoryname'],
      mangaList: mangaList,
    );
  }
}
