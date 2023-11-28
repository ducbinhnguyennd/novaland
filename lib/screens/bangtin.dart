import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loginapp/constant/asset_path_const.dart';
import 'package:loginapp/constant/common_service.dart';
import 'package:loginapp/constant/strings_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/bangtin_model.dart';
import 'package:loginapp/model/user_model.dart';
import 'package:loginapp/routes.dart';
import 'package:loginapp/screens/binhluan_screen.dart';
import 'package:loginapp/screens/postbai.dart';
import 'package:loginapp/screens/thongbao_screen.dart';
import 'package:loginapp/user_Service.dart';
import 'package:loginapp/widgets/item_bangtin.dart';

import '../constant/colors_const.dart';

class BangTinScreen extends StatefulWidget {
  const BangTinScreen({Key? key}) : super(key: key);
  static const routeName = 'bangtin';

  @override
  State<BangTinScreen> createState() => _BangTinScreenState();
}

class _BangTinScreenState extends State<BangTinScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  Data? currentUser;
  int selectedTabIndex = 0;
  bool nutlike = false;
  Bangtin? bangtin;
  ApiBangTin apiBangTin = ApiBangTin();
  ApiBangTinDaLog apiBangTinDaLog = ApiBangTinDaLog();
  Future<void> _refresh() async {
    await _loadUser();
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<List<Bangtin>> _fetchPosts() {
    if (currentUser == null) {
      return apiBangTin.getPosts();
    } else {
      return apiBangTinDaLog.getPosts(currentUser?.user[0].id ?? '');
    }
  }

  Future<void> _loadUser() async {
    UserServices us = UserServices();
    us.getInfoLogin().then((value) {
      if (value != "") {
        setState(() {
          currentUser = Data.fromJson(jsonDecode(value));
          nutlike = bangtin?.isLiked ?? false;
        });
      } else {
        setState(() {
          currentUser = null;
        });
      }
    }, onError: (error) {}).then((value) async {
      print('userid: ${currentUser?.user[0].id}');
    });
  }

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        // toolbarHeight: 40,
        centerTitle: true,
        backgroundColor: ColorConst.colorPrimary50,
        elevation: 0,
        title: Text(
          'Bảng tin',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        color: ColorConst.colorPrimary120,
        onRefresh: _refresh,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 13,
              color: Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CircleAvatar(
                      backgroundColor: ColorConst.colorPrimary,
                      child: Text(
                        currentUser?.user[0].username
                                .toString()
                                .substring(0, 1) ??
                            'Login',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 13.0, 8.0, 13.0),
                      child: InkWell(
                        onTap: () {
                          if (currentUser != null &&
                              currentUser!.user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PostBaiVietScreen(
                                      userId: currentUser?.user[0].id ?? '')),
                            ).then((value) {
                              _loadUser();
                            });
                          } else {
                            _showToast(StringConst.textyeucaudangnhap);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child:
                              const Center(child: Text('Bạn đang nghĩ gì ?')),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: (() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationScreen(
                                      userID: currentUser?.user[0].id ?? '',
                                    )),
                          );
                        }),
                        child: Image.asset(
                          AssetsPathConst.categoryBell,
                          height: 25,
                          color: ColorConst.colorPrimary120,
                        ),
                      ))
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Bangtin>>(
                future: _fetchPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: ColorConst.colorPrimary120,
                    ));
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    List<Bangtin> posts = snapshot.data!;
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return ItemBangTin(
                          widgetDelete:
                              (posts[index].userId == currentUser?.user[0].id)
                                  ? _item3DauCham(posts, index)
                                  : Container(),
                          username: posts[index].username,
                          like: posts[index].like,
                          content: posts[index].content,
                          date: posts[index].date,
                          cmt: posts[index].cmt.toString(),
                          useridbaiviet: posts[index].userId,
                          userid: currentUser?.user[0].id,
                          idbaiviet: posts[index].id,
                          isLike: posts[index].isLiked,
                          comments: posts[index].comments ?? [],
                          widgetPostCM: binhluon(posts[index].comments ?? [],
                              posts[index].id, currentUser?.user[0].id ?? ''),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell _item3DauCham(List<Bangtin> posts, int index) {
    return InkWell(
      onTap: () {
        if (posts[index].userId == currentUser?.user[0].id) {
          _showDeleteDialog(posts[index].id, currentUser?.user[0].id ?? '');
        }
      },
      child: Icon(
        Icons.more_vert,
        size: 22,
      ),
    );
  }

  void _showDeleteDialog(String idPost, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa bài viết'),
          content: Text('Bạn có chắc muốn xóa bài viết này?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                await XoaBaiDang.xoaBaiDang(idPost, userId);
                Navigator.of(context).pop();
                setState(() {
                  _loadUser();
                });
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  Widget binhluon(List<Comment> comments, String baivietID, String userID) {
    return InkWell(
      onTap: (() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommentScreen(
              baivietID: baivietID,
              userID: userID,
            ),
          ),
        ).then((value) {
          if (value == true) {
            _loadUser();
          }
        });
      }),
      child: Row(
        children: [
          Icon(Icons.chat, size: 25, color: Colors.grey[350]),
          Text(' Bình luận')
        ],
      ),
    );
  }

  void _showToast(String msg) {
    if (msg.contains(StringConst.textyeucaudangnhap)) {
      // update count show user need login: only first show toast need login, after will show snack bar to go to login screen,
      // show snack bar login here,
      CommonService.showSnackBar(StringConst.textyeucaudangnhap, context, () {
        // go to login screen
        RouteUtil.redirectToLoginScreen(context);
      });
      return;
    }
    // SHOW TOAST
    CommonService.showToast(msg, context);
  }

  @override
  bool get wantKeepAlive => true;
}
