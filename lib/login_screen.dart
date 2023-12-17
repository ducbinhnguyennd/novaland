import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loginapp/constant/asset_path_const.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/main_screen.dart';
import 'package:loginapp/register_screen.dart';
import 'package:loginapp/screens/quenmk_screen.dart';
import 'package:loginapp/user_Service.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  static const routeName = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _username = '';
  String tt = '';
  String _password = '';
  TextEditingController userEditingController = TextEditingController();
  TextEditingController passwEditingController = TextEditingController();
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  Login login = Login();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              AssetsPathConst.bgintro,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.8,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, ColorConst.colorPrimary],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: 30,
                      blurRadius: 40,
                      offset: Offset(0, -25),
                    ),
                  ]),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Chào mừng bạn đến với',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
              Text('MangaLand',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500)),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 120, 20, 20),
                child: textField(),
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuenMatKhauScreen()),
                    );
                  },
                  child: Text('Quên mật khẩu?'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () async {
                        var response = await login.signIn(_username, _password);

                        if (response?.data['success'] == true) {
                          UserServices us = UserServices();
                          await us.saveinfologin(
                              jsonEncode(response?.data['data']));
                          // final storage = new FlutterSecureStorage();

                          print('${response?.data['data']}');
                          Navigator.pushReplacement<void, void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const MainScreen(),
                            ),
                          );
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Sai tài khoản hoặc mật khẩu"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                );
                              });
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: ColorConst.colorPrimary50),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Đăng nhập',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )),
                        ),
                      )),
                  SizedBox(
                    width: 40,
                  ),
                  InkWell(
                      onTap: () async {
                        Navigator.pushNamed(context, RegisterScreen.routeName);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: ColorConst.colorPrimary50),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Đăng ký',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    String? labelText,
    String? hintText,
    IconData? prefixIcon,
    TextEditingController? controller,
    Function(String)? onChanged,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      obscureText: isPassword,
      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      showCursor: true,
      cursorColor: Color.fromARGB(255, 0, 0, 0),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
        labelStyle: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 16,
            fontWeight: FontWeight.w300),
        prefixIcon: Icon(
          prefixIcon,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 1),
            borderRadius: BorderRadius.circular(10)),
        floatingLabelStyle: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 18,
            fontWeight: FontWeight.w300),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Column textField() {
    return Column(
      children: [
        buildTextField(
          labelText: 'Tên đăng nhập',
          hintText: 'abc',
          prefixIcon: Icons.people,
          controller: userEditingController,
          onChanged: (val) {
            setState(() {
              //isPhoneCorrect = isEmail(val);
              _username = val;
            });
          },
        ),
        SizedBox(
          height: 24,
        ),
        buildTextField(
            labelText: 'Mật khẩu',
            hintText: '******',
            prefixIcon: Icons.password_outlined,
            controller: passwEditingController,
            onChanged: (val) {
              setState(() {
                //isPhoneCorrect = isEmail(val);
                _password = val;
              });
            },
            isPassword: true),
      ],
    );
  }
}
