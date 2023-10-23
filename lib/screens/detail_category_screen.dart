import 'package:flutter/material.dart';
import 'package:loginapp/model/trangchu_model.dart';
import 'package:loginapp/widgets/item_truyenmoi.dart';

class CategoryDetailScreen extends StatelessWidget {
  final List<Manga> categoryMangas;
  final String categoryName;

  CategoryDetailScreen({required this.categoryMangas, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: ListView.builder(
        itemCount: categoryMangas.length,
        itemBuilder: (context, index) {
          return ItemTruyenMoi(
            id: categoryMangas[index].id,
            name: categoryMangas[index].mangaName,
            image: categoryMangas[index].image,
            sochap: categoryMangas[index].totalChapters.toString(),
          );
        },
      ),
    );
  }
}
