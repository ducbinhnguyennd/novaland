import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loginapp/main_screen.dart';
import 'package:loginapp/register_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loginapp/screen_tk/taikhoan.dart';
import 'package:loginapp/user_Service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
  final _storage = const FlutterSecureStorage();

  Future<Response?> signIn(String username, String password) async {
    var dio = Dio();
    try {
      var response = await dio.post(
        'https://du-an-2023.vercel.app/login',
        data: {"username": username, "password": password},
        // options: Options(
        //   // headers: {
        //   //   'content-type': 'application/x-www-form-urlencoded',
        //   //   // 'clientid': '54a0e7371788b51790082b05',
        //   // },-
        // )
      );
      print('API response status: ${response.statusCode}');
      print('API response data: ${response.data}');
      return response;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
// Future<void> saveLoginInfo(String username) async {
//   final prefs = await SharedPreferences.getInstance();
//   prefs.setString('username', username);
// }
  @override
  void initState() {
    // _storage.deleteAll();
    
    // _storage.read(key: 'nameusserr').then((value) {
    //   setState(() {
    //     tt = value ?? '';
    //     // userEditingController.text = _username;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 2,
            backgroundColor: Colors.purple,
            title: const Text("Màn hình đăng nhập"),
          ),
          body: Container(
            margin: const EdgeInsets.all(10),
            width: size.width,
            height: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(tt),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: textField(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // kiểm tra tính hợp lệ của các trường dữ liệu nhập liệu
                        var response = await signIn(_username, _password);

                        if (response?.data['success'] == true) {
                          UserServices us = UserServices();
                          await us.saveinfologin(_username);
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
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.purple)),
                      child: Text('Login'),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RegisterScreen.routeName);
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.purple)),
                      child: Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          )),
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
          labelText: 'Username',
          hintText: 'abcxyz',
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
            labelText: 'Password',
            hintText: 'alo1',
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
