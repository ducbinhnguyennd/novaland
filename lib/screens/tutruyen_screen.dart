import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/double_x.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/user_model.dart';
import 'package:loginapp/screens/detail_mangan.dart';
import 'package:loginapp/user_Service.dart';

import '../model/trangchu_model.dart';
class FavoriteMangaScreen extends StatefulWidget {
  @override
  _FavoriteMangaScreenState createState() => _FavoriteMangaScreenState();
}

class _FavoriteMangaScreenState extends State<FavoriteMangaScreen> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List<Manga> favoriteManga = [];
  Data? currentUser;

  Future<void> _refresh() async {
    await _loadUser();
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
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
    }, onError: (error) {}).then((value) async {
      print('userid: ${currentUser?.user[0].id}');
      List<Manga> mangaList =
          await ApiListYeuThich.fetchFavoriteManga(currentUser?.user[0].id ?? '');
      setState(() {
        favoriteManga = mangaList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Truyện Yêu Thích'),
        backgroundColor: ColorConst.colorPrimary50,
      ),
      body: RefreshIndicator(
        color: ColorConst.colorPrimary120,
        onRefresh: _refresh,
        child: currentUser == null
            ? Container(child: Center(
              child: Text('Bạn chưa có truyện nào yêu thích'),
            ),)
            : ListView.builder(
                itemCount: favoriteManga.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
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
                      child: Container(
                        height: MediaQuery.of(context).size.height / 7,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: ColorConst.colorPrimary120),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: CachedNetworkImage(
                                imageUrl: favoriteManga[index].image,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            DoubleX.kRadiusSizeGeneric_1XX)),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                          Colors.red.withOpacity(0.10),
                                          BlendMode.colorBurn),
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                  color: ColorConst.colorPrimary120,
                                )),
                                errorWidget: (context, url, error) =>
                                    const Center(child: Icon(Icons.error)),
                              ),
                            ),
                            Expanded(
                                flex: 7,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(favoriteManga[index].mangaName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          'Thể loại: ${favoriteManga[index].category}'),
                                      Text(
                                          'Chapter ${favoriteManga[index].totalChapters.toString()}'),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
   @override
  bool get wantKeepAlive => true;
}
