import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loginapp/login_screen.dart';
import 'package:loginapp/main_screen.dart';
import 'package:loginapp/model/user_model.dart';
import 'package:loginapp/routes.dart';
import 'package:loginapp/screen_tk/huongdan_screen.dart';
import 'package:loginapp/screen_tk/lichsugiaodich.dart';
import 'package:loginapp/screen_tk/lienhe.dart';
import 'package:loginapp/screen_tk/suathongtin.dart';
import 'package:loginapp/screen_tk/themtienthach.dart';
import 'package:loginapp/screen_tk/xoataikhoan.dart';
import 'package:loginapp/user_Service.dart';
import 'package:loginapp/widgets/item_card_taikhoan.dart';

class TaikhoanScreen extends StatefulWidget {
  const TaikhoanScreen({super.key});

  @override
  State<TaikhoanScreen> createState() => _TaikhoanScreenState();
}

class _TaikhoanScreenState extends State<TaikhoanScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int _backButtonCount = 0;
  Data? currentUser;

  _loadUser() {
    UserServices us = UserServices();
    us.getInfoLogin().then((value) {
      print('binh bug 123:$value');

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
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return LoginScreen();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.purple,
          centerTitle: true,
          title: Text('Tài khoản'),
        ),
        body: Column(
          children: [
            Container(
              height: 190, // Chiều cao của Card
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 219, 219, 219), // Màu nền của Card
                borderRadius: BorderRadius.circular(4), // Bo góc Card
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 3), // Độ lệch của đổ bóng
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Ảnh bên trái
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://bedental.vn/wp-content/uploads/2022/11/ce4f544cf302130777ecf32e24b1b9f8.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                  ),
                  // Tiêu đề bên phải
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: 30, left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentUser?.user[0].username ?? 'Binhchos',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.red),
                              ),
                              Text(
                                'user',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                // margin: EdgeInsets.only(left: 10),
                                width: 40,
                                height: 50,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        'https://static.vecteezy.com/system/resources/previews/006/960/221/non_2x/flame-meteorite-meteor-rain-fall-on-planet-in-vector.jpg'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tiên Thạch:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Tiên Thạch KM:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Ngọc Phiếu: ${currentUser?.user[0].role}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(ThemTienThach.routeName);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.purple,
                              fixedSize: Size(170, 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Thêm tiên thạch',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ItemCardTaiKhoanWidget(
              title: 'Hướng dẫn',
              onTap: () {
                Navigator.of(context).pushNamed(HuongDanScreen.routeName);
              },
            ),
            ItemCardTaiKhoanWidget(
              title: 'Nhập gift code',
              onTap: () {},
            ),
            ItemCardTaiKhoanWidget(
              title: 'Chỉnh sửa thông tin',
              onTap: () {
                Navigator.of(context).pushNamed(SuaThongTin.routeName);
              },
            ),
            ItemCardTaiKhoanWidget(
              title: 'Lịch sử giao dịch',
              onTap: () {
                Navigator.of(context).pushNamed(LichSuGiaoDich.routeName);
              },
            ),
            ItemCardTaiKhoanWidget(
              title: 'Liên hệ, báo lỗi',
              onTap: () {
                Navigator.of(context).pushNamed(LienHe.routeName);
              },
            ),
            ItemCardTaiKhoanWidget(
              title: 'Xóa tài khoản',
              onTap: () {
                Navigator.of(context).pushNamed(XoaTaiKhoan.routeName);
              },
            ),
            ItemCardTaiKhoanWidget(
              title: 'Đăng xuất',
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Xác nhận đăng xuất'),
                      content: Text('Bạn có chắc chắn muốn đăng xuất?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Đóng hộp thoại
                          },
                          child: Text('Không'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            RouteUtil.redirectToLoginScreen(context);
                            try {
                              UserServices us = UserServices();
                              await us.deleteinfo();
                              setState(() {
                                currentUser = null;
                              });
                              print('Deleted user data.');
                            } catch (err) {
                              print(err);
                            }
                            ; // Thực hiện đăng xuất
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.purple),
                          ),
                          child: Text(
                            'Có',
                            style: TextStyle(),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
