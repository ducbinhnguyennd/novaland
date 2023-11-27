import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loginapp/Globals.dart';
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
  bool _isLoading = true;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Giới thiệu:'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            content,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

  buildDocTiep(MangaDetailModel? detail) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailChapter(
                    idUser: currentUser!.user[0].id,
                    chapterId: detail?.chapters[0].idchap ?? '',
                    storyName: detail?.chapters[0].namechap,
                    storyId: widget.mangaId,
                    viporfree: detail!.chapters[0].viporfree,
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 0.5),
              color: ColorConst.colorPrimary,
              height: 70,
              child: Center(
                child: Text(
                  'Đọc từ đầu',
                  maxLines: 1,
                  style: const TextStyle(
                    color: ColorConst.colorPrimaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: DoubleX.kFontSizeTiny_1XX,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: InkWell(
            onTap: (chapterDocTiepId == null || chapterDocTiepId!.length <= 2)
                ? () {
                    Container();
                  }
                : () {
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailChapter(
                            idUser: currentUser!.user[0].id,
                            chapterId: chapterDocTiepId ??
                                detail?.chapters[0].idchap ??
                                '',
                            storyName: chapterTitleDocTiep,
                            storyId: widget.mangaId,
                            viporfree: detail!.chapters[0].viporfree,
                          ),
                        ),
                      );
                    }
                  },
            child: Container(
              margin: EdgeInsets.only(left: 1),
              color: chapterTitleDocTiep != 'Đọc tiếp'
                  ? ColorConst.colorPrimary
                  : ColorConst.colorPrimary.withOpacity(0.6),
              height: 70,
              child: Center(
                child: Text(
                  'Đọc tiếp',
                  maxLines: 1,
                  style: const TextStyle(
                    color: ColorConst.colorPrimaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: DoubleX.kFontSizeTiny_1XX,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  // buildDocTiep(MangaDetailModel? detail) {
  //   return Container(
  //     child: Row(children: [
  //       InkWell(
  //         onTap: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => DetailChapter(
  //                 idUser: currentUser!.user[0].id,
  //                 chapterId:
  //                     chapterDocTiepId ?? detail?.chapters[0].idchap ?? '',
  //                 storyName: chapterTitleDocTiep,
  //                 storyId: widget.mangaId,
  //                 viporfree: detail!.chapters[0].viporfree,
  //               ),
  //             ),
  //           );
  //         },
  //         child: Text('Đọc tiếp'),
  //       )
  //     ]),
  //   );
  // }

  buildThongSo(String follow, String view, String chap, String binhluan) {
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
              binhluan,
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
          backgroundColor: ColorConst.colorPrimary50,
          title: Text('Đang tải...'),
        ),
        body: Center(
          child: CircularProgressIndicator(
            color: ColorConst.colorPrimary,
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConst.colorPrimary50,
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
                  idUser: currentUser!.user[0].id,
                  chapterId: mangaDetail?.chapters[index].idchap ?? '',
                  storyName: mangaDetail?.chapters[index].namechap,
                  storyId: widget.mangaId,
                  viporfree: mangaDetail!.chapters[index].viporfree,
                ),
              ),
            ).then((value) {
              setState(() {
                _loadData();
                _loadUser();
              });
            });
          },
          child: ListTile(
            title: Text('Chapter ${mangaDetail?.chapters[index].namechap}'),
            subtitle: Text('Loại: ${mangaDetail?.chapters[index].viporfree}'),
            trailing: _buildChapterIcon(mangaDetail!.chapters[index].viporfree),
          ),
        );
      },
    );
  }

  Widget _buildChapterIcon(String vipOrFree) {
    if (vipOrFree.toLowerCase() == 'vip') {
      return Icon(Icons.lock, color: ColorConst.colorPrimary50);
    } else {
      return Icon(Icons.lock_open, color: Colors.green);
    }
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
                    bool isCurrentUserComment = currentUser?.user[0].id ==
                        mangaDetail?.cmts[index].userIdcmt;
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 0),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        // decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(15),
                        //     color: ColorConst.colorPrimary80),
                        child: Row(
                          children: [
                            SizedBox(
                              width: DoubleX.kSizeLarge_1X,
                              height: DoubleX.kSizeLarge_1X,
                              child: CircleAvatar(
                                backgroundColor: ColorConst.colorPrimary80,
                                child: Text(
                                  mangaDetail?.cmts[index].usernamecmt
                                          .toString()
                                          .substring(0, 1) ??
                                      '',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      mangaDetail?.cmts[index].usernamecmt ??
                                          '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Text(mangaDetail?.cmts[index].noidung ?? ''),
                                  // Text(mangaDetail?.cmts[index].date ?? ''),
                                ],
                              ),
                            ),
                            isCurrentUserComment
                                ? IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      deleteComment(
                                          mangaDetail?.cmts[index].idcmt,
                                          widget.mangaId,
                                          mangaDetail?.cmts[index].userIdcmt);
                                      _loadUser();
                                    },
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: ColorConst.colorPrimary120),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: commentController,
                      decoration: InputDecoration(
                        labelText: 'Nhập bình luận',
                        focusColor: Colors.black,
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
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
                            currentUser?.user[0].id ?? '',
                            widget.mangaId,
                            comment);
                        commentController.clear();
                        _loadUser();
                      } else {
                        Fluttertoast.showToast(
                          msg: "Nhập ít nhất 10 kí tự",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                        );
                      }
                    },
                    child: Icon(
                      Icons.send_rounded,
                      color: ColorConst.colorPrimary50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void deleteComment(String? commentId, String? mangaId, String? userId) {
    XoaComment.xoaComment(commentId!, mangaId!, userId!).then((response) {
      Fluttertoast.showToast(
        msg: "Xóa bình luận thành công",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: "Xóa bình luận thất bại",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    });
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
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Image.network(
                  mangaDetail?.image ?? '',
                  height: 230,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Icon(Icons.error);
                  },
                ),
              ),
              Positioned(
                left: 20,
                top: 20,
                right: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: CachedNetworkImage(
                        imageUrl: mangaDetail?.image ?? '',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: 180,
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Truyện: ${mangaDetail?.mangaName}',
                              style: TextStyle(
                                shadows: [
                                  Shadow(
                                    color: Colors.white,
                                    blurRadius:
                                        1.0, // Điều chỉnh mức độ mờ của shadow
                                    offset: Offset(0.0,
                                        1.0), // Điều chỉnh vị trí của shadow
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Tác giả: ${mangaDetail?.author}',
                              style: TextStyle(
                                shadows: [
                                  Shadow(
                                    color: Colors.white,
                                    blurRadius:
                                        1.0, // Điều chỉnh mức độ mờ của shadow
                                    offset: Offset(0.0,
                                        1.0), // Điều chỉnh vị trí của shadow
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Thể loại: ${mangaDetail?.category}',
                              style: TextStyle(
                                shadows: [
                                  Shadow(
                                      color: Colors.white,
                                      blurRadius:
                                          1.0, // Điều chỉnh mức độ mờ của shadow
                                      offset: Offset(0.0, 1.0)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),

          // buildGenresChips(),
          SizedBox(height: 15),

          buildThongSo(
              mangaDetail!.like.toString(),
              mangaDetail!.view.toString(),
              mangaDetail!.totalChapters.toString(),
              mangaDetail!.totalcomment.toString()),
          SizedBox(height: 15),
          Divider(
            color: Colors.grey,
            height: 0.2,
          ),
          SizedBox(height: 15),
          buildContent(mangaDetail!.content),
          buildFavorite(),
        ],
      ),
      bottomNavigationBar: buildDocTiep(mangaDetail!),
    );
  }

  final dio = Dio();
//  String userId = currentUser.user[0].id;

  void toggleLike() async {
    final apiUrl = nutlike
        ? 'https://mangaland.site/user/removeFavoriteManga/${currentUser!.user[0].id}/${widget.mangaId}'
        : 'https://mangaland.site/user/addFavoriteManga/${currentUser!.user[0].id}/${widget.mangaId}';

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
                  'Truyện đã được ${nutlike ? 'Thêm yêu thích' : 'Bỏ yêu thích'}.'),
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
        size: 50,
        color: nutlike ? Colors.red : ColorConst.colorPrimary120,
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
