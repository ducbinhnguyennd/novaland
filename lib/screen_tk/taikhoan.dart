import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:loginapp/Globals.dart';
import 'package:loginapp/constant/asset_path_const.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/double_x.dart';
import 'package:loginapp/login_screen.dart';

import 'package:loginapp/model/user_model.dart';
import 'package:loginapp/routes.dart';
import 'package:loginapp/screen_tk/huongdan_screen.dart';
import 'package:loginapp/screen_tk/lichsugiaodich.dart';
import 'package:loginapp/screen_tk/lienhe.dart';
import 'package:loginapp/screen_tk/suathongtin.dart';
import 'package:loginapp/screen_tk/themtienthach.dart';
import 'package:loginapp/screen_tk/xoataikhoan.dart';
import 'package:loginapp/user_Service.dart';

class TaikhoanScreen extends StatefulWidget {
  const TaikhoanScreen({super.key});

  @override
  State<TaikhoanScreen> createState() => _TaikhoanScreenState();
}

class _TaikhoanScreenState extends State<TaikhoanScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int _backButtonCount = 0;
  Data? currentUser;
  bool isSwitchedModeDarkTheme = Globals.isDarkModeTheme;
  bool isSwitchedModeRight = Globals.isRight;
  final GlobalKey _secondUserMissionKey = GlobalKey();
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
        // resizeToAvoidBottomInset: false,
        body: ListView(
          padding: EdgeInsets.all(0),
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 4,
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
                    height: MediaQuery.of(context).size.height / 4,
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
                      margin: EdgeInsets.only(left: 10),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://tiengdong.com/wp-content/uploads/www_tiengdong_com-meme-9-5-diem-huan-hoa-hong.jpg?v=1640272983'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                    Text(
                      currentUser?.user[0].username ?? 'Tên đăng nhập',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            // Text('Chức năng thành viên'),
            // Container(
            //   height: 100,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(30),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.grey.withOpacity(0.5),
            //           spreadRadius: 5,
            //           blurRadius: 7,
            //           offset: Offset(0, 3), // changes position of shadow
            //         ),
            //       ],
            //       color: ColorConst.colorPrimary80),
            //       child: Column(children: [
            //         ItemCardTaiKhoanWidget(title: 'Thay đổi ảnh đại diện', onTap: () {
            //     Navigator.of(context).pushNamed(SuaThongTin.routeName);
            //   },)
            //       ]),
            // )
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 40, bottom: 5),
              child: Text('Chức năng thành viên',
                  style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                    // fontSize: 12
                  )),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: _buildSetting(),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 40, bottom: 5),
              child: Text('Cài đặt',
                  style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                    // fontSize: 12
                  )),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: _buildSetting1(),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 40, bottom: 5),
              child: Text('Hỗ trợ người dùng',
                  style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                    // fontSize: 12
                  )),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: _buildSetting2(),
            ),
            SizedBox(height: 50),
          ],
        ),
      );
    }
  }

  bool hot18 = false;
  bool noichap = false;
  _buildSetting() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade800
              : ColorConst.colorWhite,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(LienHe.routeName);
            },
            child: ListTile(
              title: Transform.translate(
                offset: Offset(-20, 0),
                child: Text('Thay đổi ảnh đại diện/ ảnh bìa'),
              ),
              leading: ImageIcon(AssetImage(AssetsPathConst.ico_4),
                  size: 22, color: ColorConst.colorPrimary30),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(SuaThongTin.routeName);
            },
            child: ListTile(
                title: Transform.translate(
                  offset: Offset(-20, 0),
                  child: Text('Thay đổi thông tin'),
                ),
                leading: Image.asset(AssetsPathConst.ico_14, height: 22)),
          ),
          InkWell(
            onTap: () {
              // if (currentUser != null && currentUser?.user != null) {
              //   Navigator.of(context).pushNamed(LichSuGiaoDich.routeName);
              // } else {
              //   // _showToast(StringConst.textyeucaudangnhap);
              // }
            },
            child: ListTile(
                title: Transform.translate(
                  offset: Offset(-20, 0),
                  child: Text('Lịch sử giao dịch'),
                ),
                leading: Image.asset(AssetsPathConst.ico_6, height: 22)),
          ),
          Visibility(
            visible: true,
            child: InkWell(
              onTap: () {},
              child: ListTile(
                title: const Text('Xu Của Bạn'),
                leading: Image.asset(AssetsPathConst.someCoins,
                    width: DoubleX.kSizeMedium_1XX),
              ),
            ),
          ),
          Visibility(
            visible: true,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(ThemTienThach.routeName);
              },
              child: const ListTile(
                title: Text('Nạp Xu'),
                leading: Icon(
                  Icons.euro,
                  color: ColorConst.colorSecondary,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  _buildSetting1() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800
                : ColorConst.colorWhite,
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(height: 10),

            // InkWell(
            //   onTap: () {
            //     //
            //   },
            //   child: ListTile(
            //     title: Transform.translate(
            //       offset: Offset(-20, 0),
            //       child: Text('Chế độ nền'),
            //     ),
            //     leading: ImageIcon(AssetImage(AssetsPathConst.ico_7),
            //         size: 22, color: ColorConst.colorPrimary30),
            //     trailing: Switch.adaptive(
            //       onChanged: _toggleSwitchModeDarkTheme,
            //       value: isSwitchedModeDarkTheme,
            //       activeColor: ColorConst.colorPrimary30,
            //       // trackColor: Colors.grey,
            //     ),
            //   ),

            // hướng dẫn
// Navigator.of(context).pushNamed(HuongDanScreen.routeName);
            InkWell(
              onTap: () {
                setState(() {
                  hot18 = !hot18;
                });
              },
              child: ListTile(
                title: Transform.translate(
                  offset: Offset(-20, 0),
                  child: Text('Lọc nội dung 18+'),
                ),
                leading: ImageIcon(AssetImage(AssetsPathConst.ico_8),
                    size: 22, color: ColorConst.colorPrimary30),
                trailing: Switch.adaptive(
                  onChanged: (value) {
                    setState(() {
                      hot18 = !hot18;
                    });
                  },
                  value: hot18,
                  activeColor: ColorConst.colorPrimary30,
                  // trackColor: Colors.grey,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                //
              },
              child: ListTile(
                title: Transform.translate(
                  offset: Offset(-20, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Tay thuận'),
                      Text(isSwitchedModeRight ? '(Phải)' : '(Trái)'),
                    ],
                  ),
                ),
                leading: Image.asset(
                  AssetsPathConst.ico_9,
                  height: 22,
                ),
                trailing: Switch.adaptive(
                  onChanged: _toggleSwitchModeRight,
                  value: isSwitchedModeRight,
                  activeColor: ColorConst.colorPrimary30,
                  // trackColor: Colors.grey,
                ),
              ),
            ),
            // InkWell(
            //   onTap: () {
            //     //
            //   },
            //   child: ListTile(
            //     title: Transform.translate(
            //       offset: Offset(-20, 0),
            //       child: Text('Tự động bỏ qua quảng cáo'),
            //     ),
            //     leading: ImageIcon(AssetImage(AssetsPathConst.ico_10),
            //         size: 22, color: ColorConst.colorPrimary),
            //     trailing: Switch.adaptive(
            //       onChanged: (value) {},
            //       value: false,
            //       activeColor: Colors.orange,
            //       // trackColor: Colors.grey,
            //     ),
            //   ),
            // ),
            InkWell(
              onTap: () {
                setState(() {
                  noichap = !noichap;
                });
              },
              child: ListTile(
                title: Transform.translate(
                  offset: Offset(-20, 0),
                  child: Text('Tự động nối chapter'),
                ),
                leading: ImageIcon(AssetImage(AssetsPathConst.ico_11),
                    size: 22, color: ColorConst.colorPrimary30),
                trailing: Switch.adaptive(
                  onChanged: (value) {
                    setState(() {
                      noichap = !noichap;
                    });
                  },
                  value: noichap,
                  activeColor: ColorConst.colorPrimary30,
                  // trackColor: Colors.grey,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(XoaTaiKhoan.routeName);
              },
              child: ListTile(
                title: Transform.translate(
                  offset: Offset(-20, 0),
                  child: Text('Xóa tài khoản'),
                ),
                leading: ImageIcon(AssetImage(AssetsPathConst.ico_12),
                    size: 22, color: ColorConst.colorPrimary30),
                // trailing: Switch.adaptive(
                //   onChanged: (v) {
                //   if (v) {
                //     Globals.isAutoUnlockVipChap == false
                //         ? _buildDialog()
                //         : setState(() {
                //             isSwitchedAutoOpenVipChap = false;
                //             Globals.isAutoUnlockVipChap = false;
                //           });
                //   } else {
                //     setState(() {
                //       isSwitchedAutoOpenVipChap = false;
                //       Globals.isAutoUnlockVipChap = false;
                //     });
                //   }
                // },
                // dragStartBehavior: DragStartBehavior.start,
                // value: isSwitchedAutoOpenVipChap,
                // activeColor: ColorConst.colorPrimary30,
                // trackColor: Colors.grey,
              ),
            ),
          ]),
        ));
  }

  _buildSetting2() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade800
              : ColorConst.colorWhite,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(height: 10),
          ListTile(
            title: Transform.translate(
              offset: Offset(-20, 0),
              child: Text('Chăm sóc khách hàng'),
            ),
            leading: ImageIcon(
              AssetImage(AssetsPathConst.ico_1),
              color: ColorConst.colorPrimary30,
              size: 22,
            ),
            trailing: Container(
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(LienHe.routeName);
                    },
                    child:
                        //  AssetImage(AssetsPathConst.ico_face),
                        Image.asset(
                      AssetsPathConst.ico_face,
                      height: 23,
                    ),

                    // color: Theme.of(context).brightness == Brightness.dark
                    //     ? Colors.white
                    //     : Colors.black,
                  ),
                  SizedBox(width: 15),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(LienHe.routeName);
                    },
                    child:
                        //  AssetImage(AssetsPathConst.ico_face),
                        Image.asset(
                      AssetsPathConst.ico_tiktok,
                      height: 21,
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ),
          ),
          //
          Visibility(
            visible: true,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(HuongDanScreen.routeName);
              },
              child: const ListTile(
                title: Text('Hướng dẫn'),
                leading: Icon(
                  Icons.integration_instructions_outlined,
                  color: ColorConst.colorPrimary50,
                ),
              ),
            ),
          ),
          InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Xác nhận đăng xuất'),
                      content: Text('Bạn có chắc chắn muốn đăng xuất?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
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
              child: ListTile(
                  title: Transform.translate(
                    offset: Offset(-20, 0),
                    child: Text('Đăng xuất'),
                  ),
                  leading: Image.asset(AssetsPathConst.ico_13, height: 22)))
        ]),
      ),
    );
  }

  // _toggleSwitchModeDarkTheme(bool value) {
  //   // update theme value status
  //   Globals.isDarkModeTheme = value;
  //   final provider = Provider.of<ThemeProvider>(context, listen: false);
  //   provider.toggleTheme(value);

  //   if (isSwitchedModeDarkTheme == false) {
  //     setState(() {
  //       isSwitchedModeDarkTheme = true;
  //     });
  //   } else {
  //     setState(() {
  //       isSwitchedModeDarkTheme = false;
  //     });
  //   }
  // }

  _toggleSwitchModeRight(bool value) {
    Globals.isRight = value;

    if (isSwitchedModeRight == false) {
      setState(() {
        isSwitchedModeRight = true;
      });
    } else {
      setState(() {
        isSwitchedModeRight = false;
      });
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
