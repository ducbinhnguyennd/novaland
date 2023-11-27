import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/model/user_model.dart';
import 'package:loginapp/user_Service.dart';

class SuaThongTin extends StatefulWidget {
  const SuaThongTin({super.key});
  static const routeName = 'suathongtin';

  @override
  State<SuaThongTin> createState() => _SuaThongTinState();
}

class _SuaThongTinState extends State<SuaThongTin> {
  final _formKey = GlobalKey<FormState>();

  final _usernameKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  // final _emailKey = GlobalKey<FormFieldState>();
  // final _phoneKey = GlobalKey<FormFieldState>();
  Data? currentUser;


  final _emailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  // TextEditingController emailEditingController = TextEditingController();
  // TextEditingController phoneEditingController = TextEditingController();
  TextEditingController userEditingController = TextEditingController();
  TextEditingController passwEditingController = TextEditingController();

  bool isEmailCorrect = false;
  String _username = '';
  String _password = '';

  @override
  void dispose() {
    // emailEditingController.dispose();
    super.dispose();
  }
  Future<Response?> Register1(
      String username, String password) async {
    var dio = Dio();
    if (userEditingController.text == '' &&
        passwEditingController.text == '' 
      ) {
      print('chua co gi ca');
    } else {
      try {
        var response = await dio.post(
            'https://mangaland.site/userput/${currentUser?.user[0].id}',
            data: {
              "username": username,
              "password": password
            },
           );
        if (kDebugMode) {
          print(response.data);
        }
        return response;
      } catch (e) {
        print(e);
      }
    }
    return null;
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
    }, onError: (error) {
     
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: const Text('Thông tin cá nhân'),
      ),
      body: Container(
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
                    doValidation(_usernameKey, null);
                    _username = val;
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: "Username"),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'nhap lai';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: passwEditingController,
                  key: _passwordKey,
                  onChanged: (val) {
                    doValidation(_passwordKey, null);
                    _password = val;
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: "Password"),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'nhap lai';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
               
                ElevatedButton(
                  onPressed: () {
                 
                      Register1(_username, _password);
                    
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.purple), // Màu nền tím
                  ),
                  child: Text('Lưu'),
                ),
               
              ],
            )),
      ),
    );
  }

  void doValidation(
      GlobalKey<FormFieldState>? keyName, GlobalKey<FormState>? formKey) {
    if (formKey != null && formKey.currentState!.validate()) {}
  }
}
