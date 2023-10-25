import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/common_service.dart';
import 'package:loginapp/constant/double_x.dart';
import 'package:loginapp/constant/strings_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/detailtrangchu_model.dart';
import 'package:loginapp/routes.dart';
import 'package:loginapp/screens/detai_chapter.dart';
import 'package:loginapp/user_Service.dart';

class MangaDetailScreen extends StatefulWidget {
  final String mangaId;
  final String storyName;

  const MangaDetailScreen(
      {super.key, required this.mangaId, required this.storyName});

  @override
  _MangaDetailScreenState createState() => _MangaDetailScreenState();
}

class _MangaDetailScreenState extends State<MangaDetailScreen>
    with TickerProviderStateMixin {
  late Future<MangaDetailModel> mangaDetail;
  String? chapterDocTiepId;
  String? chapterDocTuDau;
  late TabController _controller;
  int _currentTabIndex = 0;
  String chapterTitleDocTiep = "Đọc tiếp";
  @override
  void initState() {
    super.initState();
    _loadData();
    mangaDetail = MangaDetail.fetchMangaDetail(widget.mangaId);
    _controller = TabController(length: 3, vsync: this);
    _controller.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      _currentTabIndex = _controller.index;
    });
  }

  // Widget buildGenresChips() {
  //   if (_bookDetail!.genres != null && _bookDetail!.genres.isNotEmpty) {
  //     List<String> genresList = _bookDetail!.genres.split(', ');

  //     List<Widget> chips = genresList.map((genre) {
  //       return Padding(
  //         padding: const EdgeInsets.all(2.0),
  //         child: Chip(
  //           backgroundColor: ColorConst.colorWarning,
  //           label: Text(
  //             genre,
  //             style: TextStyle(color: Colors.grey),
  //           ),
  //         ),
  //       );
  //     }).toList();
  //     return Wrap(
  //       children: chips,
  //     );
  //   } else {
  //     return Text("Không có thể loại");
  //   }
  // }

  buildContent(String content) {
    return Text(content);
  }

  buildDocTiep(MangaDetailModel detail) {
    return Container(
      child: Row(children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailChapter(
                  chapterId: chapterDocTiepId ?? detail.chapters[0].idchap,
                  storyName: chapterTitleDocTiep,
                  storyId: widget.mangaId,
                ),
              ),
            );
          },
          child: Text('Đọc tiếp'),
        )
      ]),
    );
  }

  buildThongSo(String follow, String view, String chap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              follow,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: DoubleX.kFontSizeTiny_1XXX),
            ),
            Text(
              'Theo dõi',
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
        Column(
          children: [
            Text(
              view,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: DoubleX.kFontSizeTiny_1XXX),
            ),
            Text(
              'Lượt xem',
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
        Column(
          children: [
            Text(
              chap,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: DoubleX.kFontSizeTiny_1XXX),
            ),
            Text(
              'Chapters',
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
        Column(
          children: [
            Text(
              '0',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: DoubleX.kFontSizeTiny_1XXX),
            ),
            Text(
              'Bình luận',
              style: TextStyle(color: Colors.grey),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (mangaDetail == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Đang tải...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConst.colorPrimary,
          title: Text(widget.storyName),
          bottom:
              TabBar(controller: _controller, tabs: _buildTabBarTitlesList()),
        ),
        body: TabBarView(
          controller: _controller,
          children: <Widget>[
            buildGioiThieu(),
            buildChapter(),
            Center(
              child: Text("It's sunny here"),
            ),
          ],
        ),
      );
    }
  }

  Widget buildChapter() {
    return FutureBuilder<MangaDetailModel>(
      future: mangaDetail,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
        } else {
          if (snapshot.hasData) {
            MangaDetailModel detail = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: detail.chapters.length,
              itemBuilder: (context, index) {
                final chapter = detail.chapters[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailChapter(
                          chapterId: detail.chapters[index].idchap,
                          storyName: detail.chapters[index].namechap,
                          storyId: widget.mangaId,
                        ),
                      ),
                    ).then((value) {
                      setState(() {
                        _loadData();
                      });
                    });
                  },
                  child: ListTile(
                    title: Text('Chapter ${chapter.namechap}'),
                    subtitle: Text('Loại: ${chapter.viporfree}'),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Không có dữ liệu.'));
          }
        }
      },
    );
  }

  _loadData() {
    UserServices us = UserServices();
    us.readChuongVuaDocOfTruyen(widget.mangaId).then((data) async {
      String? sData = await data;
      if (sData != null && sData!.isNotEmpty) {
        dynamic data2 = jsonDecode(sData);
        if (mounted) {
          setState(() {
            chapterDocTiepId = data2['idchap'];
            chapterTitleDocTiep = data2['titlechap'] + " \u279C";
          });
        }
      } else {
        if (mounted) {
          // setState(() {
          //   chapterDocTiepId = MangaDetailModel.;
          // });
        }
      }
    });
  }

  Widget buildGioiThieu() {
    return FutureBuilder<MangaDetailModel>(
      future: mangaDetail,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Đã xảy ra lỗi: ${snapshot.error}');
        } else {
          if (snapshot.hasData) {
            MangaDetailModel detail = snapshot.data!;
            // print(
            //   base64Decode(detail.image),
            // );
            // Hiển thị thông tin chi tiết của Manga dựa trên dữ liệu detail.
            return Column(
              children: [
                // Image.memory(
                //   base64Decode(detail.image),
                // ),
                CachedNetworkImage(
                  imageUrl: detail.image,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: 155,
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),

                Text('Tác giả: ${detail.author}'),
                // Text('Tên Manga: ${detail.category}'),
                Text('Thể loại: ${detail.category}'),
                // buildGenresChips(),
                buildThongSo(detail.like.toString(), detail.view.toString(),
                    detail.totalChapters.toString()),
                SizedBox(height: 15),
                Divider(
                  color: Colors.grey,
                  height: 0.2,
                ),
                SizedBox(height: 15),
                buildContent(detail.content),
                buildDocTiep(detail)
              ],
            );
          } else {
            return Text('Không có dữ liệu.');
          }
        }
      },
    );
  }

  _buildTabBarTitlesList() {
    return [
      Tab(
        child: Container(
          child: Text(
            'Giới thiệu',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: DoubleX.kFontSizeTiny_1XX,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
      ),
      Tab(
        child: Text(
          'Chapter',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: DoubleX.kFontSizeTiny_1XX,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
      Tab(
        child: Text(
          'Bình luận',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: DoubleX.kFontSizeTiny_1XX,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    ];
  }
}
  // void _showToast(String ms) {
  //   if (ms.contains(StringConst.textyeucaudangnhap)) {
  //     // show snack bar login here,
  //     CommonService.showSnackBar(StringConst.textyeucaudangnhap, context, () {
  //       // go to login screen
  //       RouteUtil.redirectToLoginScreen(context);
  //     });

  //     return;
  //   }
  //   CommonService.showToast(ms, context);
  // }
