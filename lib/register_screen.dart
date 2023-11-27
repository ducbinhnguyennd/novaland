import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:loginapp/constant/asset_path_const.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/main_screen.dart';
import 'package:loginapp/user_Service.dart';
import 'package:validators/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const routeName = 'register_screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  final _phoneKey = GlobalKey<FormFieldState>();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController userEditingController = TextEditingController();
  TextEditingController passwEditingController = TextEditingController();

  bool isEmailCorrect = false;
  String _username = '';
  String _password = '';
  String _phone = '';
  bool success = false;

  @override
  void dispose() {
    // emailEditingController.dispose();
    super.dispose();
  }

  dynamic snackBar = SnackBar(
    duration: const Duration(milliseconds: 1500),
    content: const Text("Your Registration Complete"),
    action: SnackBarAction(
      label: 'Got it',
      onPressed: () {},
    ),
  );

  Future<Response?> Register(
      String username, String password, String phone) async {
    var dio = Dio();
    if (userEditingController.text.isEmpty) {
      showSnackBar(context, 'Username đang trống');
    } else if (passwEditingController.text.isEmpty) {
      showSnackBar(context, 'Password đang trống');
    } else if (phone.isEmpty) {
      showSnackBar(context, 'Số điện thoại đang trống');
    } else if (phone.length != 10) {
      showSnackBar(context, 'Số điện thoại phải đủ 10 số');
    } else if (!phone.startsWith('0')) {
      showSnackBar(context, 'Số điện thoại đầu 0');
    } else {
      try {
        var response = await dio.post('https://mangaland.site/register',
            data: {"username": username, "password": password, "phone": phone},
            options: Options(
              headers: {
                'content-type': 'application/x-www-form-urlencoded',
              },
            ));
        print(response.data);
       setState(() {
        success =true;
         showSnackBar(context, 'Đăng ký tài khoản thành công');
       });
        
                    
        return response;
      } catch (e) {
       
        showSnackBar(context, 'Tên tài khoản đã tồn tại');
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Image.asset(AssetsPathConst.bgintro),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.8,
              decoration: BoxDecoration(
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
          Positioned(
            bottom: 200,
            left: 10,
            right: 10,
            child: Column(
              children: [
                InkWell(
                  onTap: (() {
                    Navigator.of(context).pop();
                  }),
                  child: Container(
                    child: Row(
                      children: [
                        Image.asset(
                          AssetsPathConst.ico_back,
                          height: 22,
                          width: 22,
                        ),
                        Text(
                          'Màn hình đăng nhập',
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: userEditingController,
                            key: _usernameKey,
                            onChanged: (val) {
                              _username = val;
                            },
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.deepPurple),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                labelText: "Username"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            key: _passwordKey,
                            controller: passwEditingController,
                            onChanged: (val) {
                        
                              _password = val;
                            },
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.deepPurple),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                labelText: "Password"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            key: _phoneKey,
                            onChanged: (val) {
                              doValidation(_phoneKey, null);
                              _phone = val;
                            },
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ], // Chỉ cho phép nhập số
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: ColorConst.colorPrimary50),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: "So dien thoai",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                              onTap: () async {
                                Register(_username, _password, _phone).then((value) async {
                                  Login login = Login();
                                  var response = await login.signIn(_username, _password);
          
                            if (response?.data['success'] == true) {
                              UserServices us = UserServices();
                              await us.saveinfologin(jsonEncode(response?.data['data']));
                              // final storage = new FlutterSecureStorage();
                             
                              print('${response?.data['data']}');
                              Navigator.pushReplacement<void, void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const MainScreen(),
                                ),
                              );
                            }
                                });
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
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void doValidation(
      GlobalKey<FormFieldState>? keyName, GlobalKey<FormState>? formKey) {
    if (formKey != null && formKey.currentState!.validate()) {}
  }

  void showSnackBar(BuildContext context, String msg) {
    SnackBar snackBar = SnackBar(
      backgroundColor: success ? Colors.green :Colors.red,
      behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: 1000),
      content: Text(
        msg,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
