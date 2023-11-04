import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/common_service.dart';
import 'package:loginapp/constant/double_x.dart';
import 'package:loginapp/constant/strings_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/login_screen.dart';
import 'package:loginapp/model/detailtrangchu_model.dart';
import 'package:loginapp/routes.dart';
import 'package:loginapp/screens/detai_chapter.dart';
import 'package:loginapp/user_Service.dart';
import 'package:like_button/like_button.dart';

import '../model/user_model.dart';

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
  MangaDetailModel? mangaDetail;
  String? chapterDocTiepId;
  String? chapterDocTuDau;
  late TabController _controller;
  bool nutlike = false;
  int _currentTabIndex = 0;
  String chapterTitleDocTiep = "Đọc tiếp";
  Data? currentUser;
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
      if (kDebugMode) {
        print(
            '_alexTR_logging_ : SettingPage: _loadUser: error: ${error.toString()}');
      }
    }).then((value) {
      MangaDetail.fetchMangaDetail(
              widget.mangaId, currentUser?.user[0].id ?? '')
          .then((value) {
        print('value day $value');
        setState(() {
          mangaDetail = value;
          nutlike = mangaDetail?.isLiked ?? false;
        });
      });
      print('in data ra day $mangaDetail');
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadUser();

    _controller = TabController(length: 3, vsync: this);
    _controller.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      _currentTabIndex = _controller.index;
    });
  }

  buildContent(String content) {
    return Text(content);
  }

  buildDocTiep(MangaDetailModel? detail) {
    return Container(
      child: Row(children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailChapter(
                  chapterId:
                      chapterDocTiepId ?? detail?.chapters[0].idchap ?? '',
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
    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            child: Text('Đăng nhập đi các cu em'),
          ),
        ),
      );
    } else if (mangaDetail == null) {
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
          children: <Widget>[buildGioiThieu(), buildChapter(), buildComments()],
        ),
      );
    }
  }

  Widget buildChapter() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: mangaDetail?.chapters.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailChapter(
                  chapterId: mangaDetail?.chapters[index].idchap ?? '',
                  storyName: mangaDetail?.chapters[index].namechap,
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
            title: Text('Chapter ${mangaDetail?.chapters[index].namechap}'),
            subtitle: Text('Loại: ${mangaDetail?.chapters[index].viporfree}'),
          ),
        );
      },
    );
  }

  final TextEditingController commentController = TextEditingController();
  Widget buildComments() {
    return Column(
      children: [
       Expanded(
  child: mangaDetail!.cmts.isEmpty
      ? Center(
          child: Text('Chưa có bình luận'),
        )
      : ListView.builder(
          shrinkWrap: true,
          itemCount: mangaDetail?.cmts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Username ${mangaDetail?.cmts[index].usernamecmt}'),
              subtitle: Text('Nội dung: ${mangaDetail?.cmts[index].noidung}'),
            );
          },
        ),
),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),color: ColorConst.colorPrimary120
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: commentController,
                      decoration: InputDecoration(labelText: 'Nhập bình luận', focusColor: Colors.black,),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      String comment = commentController.text;
                      if (comment.isNotEmpty && comment.length >= 10) {
                         Fluttertoast.showToast(
                          msg: "Đăng bình luận thành công",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                        );
                        CommentService.postComment(
                            currentUser?.user[0].id ?? '', widget.mangaId, comment);
                        commentController.clear();
    _loadData();

                      } else {
                        Fluttertoast.showToast(
                          msg: "Nhập ít nhất 10 kí tự",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                        );
                      }
                    },
                    child: Icon(Icons.send_rounded, color: ColorConst.colorPrimary50,),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
    return Column(
      children: [
        // Image.memory(
        //   base64Decode(detail.image),
        // ),
        CachedNetworkImage(
          imageUrl: mangaDetail?.image ?? '',
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

        Text('Tác giả: ${mangaDetail?.author}'),
        // Text('Tên Manga: ${detail.category}'),
        Text('Thể loại: ${mangaDetail?..category}'),
        // buildGenresChips(),
        buildThongSo(mangaDetail!.like.toString(), mangaDetail!.view.toString(),
            mangaDetail!.totalChapters.toString()),
        SizedBox(height: 15),
        Divider(
          color: Colors.grey,
          height: 0.2,
        ),
        SizedBox(height: 15),
        buildContent(mangaDetail!.content),
        buildFavorite(),
        buildDocTiep(mangaDetail!)
      ],
    );
  }

  final dio = Dio();
//  String userId = currentUser.user[0].id;

  void toggleLike() async {
    final apiUrl = nutlike
        ? 'https://du-an-2023.vercel.app/user/removeFavoriteManga/${currentUser!.user[0].id}/${widget.mangaId}'
        : 'https://du-an-2023.vercel.app/user/addFavoriteManga/${currentUser!.user[0].id}/${widget.mangaId}';

    try {
      final response = await dio.post(apiUrl);

      if (response.statusCode == 200) {
        setState(() {
          nutlike = !nutlike;
        });

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Thành công'),
              content: Text(
                  'Truyện đã được ${nutlike ? 'Bỏ yêu thích' : 'Thêm yêu thích'}.'),
            );
          },
        );
      }
    } catch (e) {
      // Xử lý lỗi nếu có
    }
  }

  buildFavorite() {
    return InkWell(
      onTap: toggleLike,
      child: Icon(
        nutlike ? Icons.favorite : Icons.favorite_border,
        size: 100,
        color: nutlike ? Colors.red : Colors.blue,
      ),
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
