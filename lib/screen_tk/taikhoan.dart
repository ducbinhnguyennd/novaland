import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loginapp/Globals.dart';
import 'package:loginapp/constant/asset_path_const.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/login_screen.dart';
import 'package:loginapp/main_screen.dart';
import 'package:loginapp/model/user_model.dart';
import 'package:loginapp/model/user_model2.dart';
import 'package:loginapp/screen_tk/doimatkhau.dart';
import 'package:loginapp/screen_tk/huongdan_screen.dart';
import 'package:loginapp/screen_tk/lichsugiaodich.dart';
import 'package:loginapp/screen_tk/lienhe.dart';
import 'package:loginapp/screen_tk/suathongtin.dart';
import 'package:loginapp/screen_tk/themtienthach.dart';
import 'package:loginapp/user_Service.dart';

class TaikhoanScreen extends StatefulWidget {
  const TaikhoanScreen({super.key});

  @override
  State<TaikhoanScreen> createState() => _TaikhoanScreenState();
}

class _TaikhoanScreenState extends State<TaikhoanScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  Data? currentUser;
  bool isSwitchedModeDarkTheme = Globals.isDarkModeTheme;
  bool isSwitchedModeRight = Globals.isRight;
  final GlobalKey _secondUserMissionKey = GlobalKey();
  late Future<UserModel> futureUserData;
  bool isSwitchedAutoNoiChap = Globals.isAutoNoiChap;

  final ApiUser apiService = ApiUser();
  _loadUser() {
    UserServices us = UserServices();
    us.getInfoLogin().then((value) {
      if (value != "") {
        setState(() {
          currentUser = Data.fromJson(jsonDecode(value));
          futureUserData =
              apiService.fetchUserData(currentUser?.user[0].id ?? '');
        });
      } else {
        setState(() {
          currentUser = null;
        });
      }
    }, onError: (error) {});
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _refresh() async {
    await _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return LoginScreen();
    } else {
      return RefreshIndicator(
        color: ColorConst.colorPrimary120,
        onRefresh: _refresh,
        child: Scaffold(
            // resizeToAvoidBottomInset: false,
            body: FutureBuilder<UserModel>(
                future: futureUserData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: ColorConst.colorPrimary120,
                    ));
                  } else if (snapshot.hasError) {
                    return Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(fontSize: 30),
                    );
                  } else {
                    final userData = snapshot.data!;
                    return ListView(
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
                                    offset: Offset(
                                        0, 3), // changes position of shadow
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
                                    child: userData.avatar == ''
                                        ? Center(
                                            child: Text(
                                              userData.username.substring(0, 1),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                                color: ColorConst
                                                    .colorBackgroundStory,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: MemoryImage(base64Decode(
                                                    userData.avatar)),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  userData.username,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                                Text(
                                  'Xu của bạn: ${userData.coin.toString()}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 20.0, top: 40, bottom: 5),
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
                          padding:
                              EdgeInsets.only(left: 20.0, top: 40, bottom: 5),
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
                          padding:
                              EdgeInsets.only(left: 20.0, top: 40, bottom: 5),
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
                    );
                  }
                })),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SuaThongTin(
                          userID: currentUser?.user[0].id ?? '',
                        )),
              ).then((result) {
                if (result.dataToPass == true) {
                  setState(() {
                    _loadUser();
                  });
                }
              });
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(
                          userId: currentUser?.user[0].id ?? '',
                          username: currentUser?.user[0].username ?? '',
                        )),
              );
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LichSuGiaoDich(userId: currentUser?.user[0].id ?? '')),
              );
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
              onTap: () {
                Navigator.of(context).pushNamed(ThemTienThach.routeName);
              },
              child: ListTile(
                title: Transform.translate(
                  offset: Offset(-20, 0),
                  child: Text('Nạp Xu'),
                ),
                leading: Icon(
                  Icons.euro,
                  color: ColorConst.colorPrimary50,
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
            InkWell(
              child: ListTile(
                title: Transform.translate(
                  offset: Offset(-20, 0),
                  child: Text('Tự động nối chapter'),
                ),
                leading: Image.asset(
                  AssetsPathConst.ico_11,
                  height: 22,
                ),
                trailing: Switch.adaptive(
                  onChanged: (v) {
                    if (v) {
                      setState(() {
                        isSwitchedAutoNoiChap = true;
                        Globals.isAutoNoiChap = true;
                      });
                    } else {
                      setState(() {
                        isSwitchedAutoNoiChap = false;
                        Globals.isAutoNoiChap = false;
                      });
                    }
                  },
                  value: isSwitchedAutoNoiChap,
                  activeColor: ColorConst.colorPrimary50,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _showDeleteConfirmationDialog();
              },
              child: ListTile(
                title: Transform.translate(
                  offset: Offset(-20, 0),
                  child: Text('Xóa tài khoản'),
                ),
                leading: ImageIcon(
                  AssetImage(AssetsPathConst.ico_12),
                  size: 22,
                  color: ColorConst.colorPrimary30,
                ),
              ),
            ),
          ]),
        ));
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận xóa tài khoản"),
          content: Text("Bạn có chắc chắn muốn xóa tài khoản không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "Hủy",
                style: TextStyle(color: Colors.black),
              ),
            ),
            InkWell(
              onTap: () async {
                await XoaUser.xoaUser(currentUser?.user[0].id ?? '');
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
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const MainScreen(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                color: ColorConst.colorPrimary50,
                child: Text('Xóa', style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
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
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(LienHe.routeName);
            },
            child: ListTile(
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
                    Image.asset(
                      AssetsPathConst.ico_face,
                      height: 23,
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
          ),
          //
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(HuongDanScreen.routeName);
            },
            child: ListTile(
              title: Transform.translate(
                offset: Offset(-20, 0),
                child: Text('Hướng dẫn'),
              ),
              leading: Icon(
                Icons.integration_instructions_outlined,
                color: ColorConst.colorPrimary50,
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
                          child: Text(
                            'Không',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pushReplacement<void, void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const MainScreen(),
                              ),
                            );
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
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ColorConst.colorPrimary50),
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
}
