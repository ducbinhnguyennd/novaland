import 'package:flutter/material.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/user_model.dart';
import 'package:loginapp/screens/detail_mangan.dart';

import '../model/trangchu_model.dart';

class FavoriteMangaScreen extends StatefulWidget {
  @override
  _FavoriteMangaScreenState createState() => _FavoriteMangaScreenState();
}

class _FavoriteMangaScreenState extends State<FavoriteMangaScreen> {
  List<Manga> favoriteManga = [];
  Data? user;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<Manga> mangaList =
          await ApiListYeuThich.fetchFavoriteManga('653a82bb9993ca568bf78ccf');
      setState(() {
        favoriteManga = mangaList;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách Manga Yêu Thích'),
      ),
      body: ListView.builder(
        itemCount: favoriteManga.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MangaDetailScreen(
                      mangaId: favoriteManga[index].id,
                      storyName: favoriteManga[index].mangaName),
                ),
              );
            },
            title: Text(favoriteManga[index].mangaName),
            subtitle: Text(favoriteManga[index].category),
            leading: Image.network(favoriteManga[index].image),
          );
        },
      ),
    );
  }
}
