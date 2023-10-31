import 'package:flutter/material.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/category_model.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final CategoryService categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: FutureBuilder<List<CategoryModel>>(
        future: categoryService.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final categories = snapshot.data;
            return ListView.builder(
              itemCount: categories!.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(category.categoryName),
                  // Add navigation or other actions here
                );
              },
            );
          }
        },
      ),
    );
  }
}
