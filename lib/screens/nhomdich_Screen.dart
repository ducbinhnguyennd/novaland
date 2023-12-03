// screen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loginapp/constant/asset_path_const.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/nhomdich_model.dart';
import 'package:loginapp/model/user_model.dart';
import 'package:loginapp/user_Service.dart';

class NhomDichScreen extends StatefulWidget {
  String nhomdichID;
  String userID;
  NhomDichScreen({super.key, required this.nhomdichID, required this.userID});
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<NhomDichScreen> {
  // late Future<NhomdichModel> _data;
  ApiDetaiNhomDich apiDetaiNhomDich = ApiDetaiNhomDich();
  bool nutlike = false;
  Data? currentUser;
  NhomdichModel? nhomdichModel;
  @override
  void initState() {
    super.initState();
    _loadUser();
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
    }, onError: (error) {}).then((value) {
      apiDetaiNhomDich
          .fetchData(widget.nhomdichID, widget.userID)
          .then((value) {
        print('value day $value');
        setState(() {
          nhomdichModel = value;
          nutlike = nhomdichModel?.isFollow ?? false;
        });
      });
      print('in data ra day $nhomdichModel');
    });
  }

  void toggleLike() async {
    final apiUrl = nutlike
        ? 'https://du-an-2023.vercel.app/unfollow/${widget.nhomdichID}/${widget.userID}'
        : 'https://du-an-2023.vercel.app/follow/${widget.nhomdichID}/${widget.userID}';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        // Text('User ID: ${nhomdichModel.userId}'),
        // Text('Username: ${nhomdichModel.username}'),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Colors.grey[300],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
                child: Image.asset(
                  AssetsPathConst.backgroundStoryDetail,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height / 4.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                  color: Colors.white.withOpacity(0.7),
                )),
            Column(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.17),
                        blurRadius: 10,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: nhomdichModel?.avatar == ''
                        ? Center(
                            child: Text(
                              nhomdichModel?.username.substring(0, 1) ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: ColorConst.colorBackgroundStory,
                              ),
                            ),
                          )
                        : Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: MemoryImage(
                                    base64Decode(nhomdichModel?.avatar ?? '')),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        toggleLike();
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: nutlike
                                  ? Colors.white
                                  : ColorConst.colorPrimary50,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            children: [
                              Image.asset(
                                nutlike
                                    ? AssetsPathConst.icodafollow
                                    : AssetsPathConst.icofollow,
                                height: 18,
                              ),
                              Text(
                                nutlike ? 'Đã follow' : 'Follow',
                                style: TextStyle(
                                    color: nutlike
                                        ? ColorConst.colorPrimary50
                                        : Colors.white),
                              )
                            ],
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        _showDialog();
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width / 4,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: ColorConst.colorPrimary50,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              'Donate',
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),
        Text('Danh sách truyện:'),
        Expanded(
          child: ListView.builder(
            itemCount: nhomdichModel?.manga.length,
            itemBuilder: (context, index) {
              final manga = nhomdichModel?.manga[index];
              return ListTile(
                title: Text(manga?.mangaName ?? ''),
                subtitle: Text('Author: ${manga?.author}'),
                // Add other information about manga here
              );
            },
          ),
        ),
      ],
    ));
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 200, // Đặt kích thước container theo mong muốn
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // Đặt bán kính bo góc
              color: Colors.blue,
            ),
            child: Center(
              child: Text(
                'Nội dung với góc bo tròn',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
