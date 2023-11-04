import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/model/category_model.dart';

class MangaListScreen extends StatelessWidget {
  final CategoryModel category;

  MangaListScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.categoryName),
        backgroundColor: ColorConst.colorPrimary50,
      ),
      body: ListView.builder(
        itemCount: category.mangaList.length,
        itemBuilder: (context, index) {
          final manga = category.mangaList[index];
          return ListTile(
            title: Text(manga.mangaName),
          );
        },
      ),
    );
  }
}
