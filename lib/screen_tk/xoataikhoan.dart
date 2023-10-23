import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/widgets/item_card_taikhoan.dart';

class XoaTaiKhoan extends StatefulWidget {
  const XoaTaiKhoan({super.key});
  static const routeName = 'xoataikhoan';

  @override
  State<XoaTaiKhoan> createState() => _XoaTaiKhoanState();
}

class _XoaTaiKhoanState extends State<XoaTaiKhoan> {
  final _usernameKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController userEditingController = TextEditingController();
  TextEditingController passwEditingController = TextEditingController();

  bool isEmailCorrect = false;
  String _username = '';
  String _password = '';

  @override
  void dispose() {
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
  // ignore: non_constant_identifier_names
  Future<Response?> Register(String username, String password) async {
    var dio = Dio();

    if (userEditingController.text == '' && passwEditingController.text == '') {
      print('chua co gi ca');
    } else {
      try {
        var response = await dio.post(
            'https://ttg5androidapi.g5manhua.com/api/thanhvien/register',
            data: {"username": username, "password": password},
            options: Options(
              headers: {
                'content-type': 'application/x-www-form-urlencoded',
              },
            ));
        print(response.data);
        return response;
      } catch (e) {
        print(e);
      }
    }
    return null;
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
                  key: _passwordKey,
                  controller: passwEditingController,
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
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    var alo = doValidation(null, _formKey);

                    Register(_username, _password);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.purple), // Màu nền tím
                  ),
                  child: Text('Xóa tài khoản'),
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

  void showSnackBar(BuildContext context, String msg) {
    SnackBar snackBar = SnackBar(
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      duration: Duration(minutes: 1),
      content: Text(
        msg,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      action: SnackBarAction(
          label: 'close',
          onPressed: () {
            debugPrint("dissmissed");
          }),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
