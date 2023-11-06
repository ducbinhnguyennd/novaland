import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/user_model.dart';
import 'package:loginapp/screens/detail_mangan.dart';
import 'package:loginapp/user_Service.dart';

import '../model/trangchu_model.dart';

class FavoriteMangaScreen extends StatefulWidget {
  @override
  _FavoriteMangaScreenState createState() => _FavoriteMangaScreenState();
}

class _FavoriteMangaScreenState extends State<FavoriteMangaScreen> {
  List<Manga> favoriteManga = [];
  Data? currentUser;
  @override
  void initState() {
    super.initState();
    _loadUser();
    // fetchData();
  }
 _loadUser() {
    UserServices us = UserServices();
    us.getInfoLogin().then((value) {
    
      if (value != "") {
        setState(() {
          currentUser = Data.fromJson(jsonDecode(value));
        });
      } else {
        setState(() {
          currentUser = null;
        });
      }
    }, onError: (error) {
     
    }).then((value) async{
       print('userid: ${currentUser?.user[0].id}');
      List<Manga> mangaList =
          await ApiListYeuThich.fetchFavoriteManga(currentUser?.user[0].id ?? '');
      setState(() {
        favoriteManga = mangaList;
      });
    });
  }

  // Future<void> fetchData() async {
  //   print('userid: ${currentUser?.user[0].id}');
  //   try {
  //     List<Manga> mangaList =
  //         await ApiListYeuThich.fetchFavoriteManga(currentUser?.user[0].id ?? '');
  //     setState(() {
  //       favoriteManga = mangaList;
  //     });
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // print(currentUser!.user[0].id);
    return Scaffold(
      
      body: currentUser ==null ?Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading :false,

          title: Text('Man hinh theo doi'),
        ),
        body: Text('ddang nhap di')
              
            
      ): ListView.builder(
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
