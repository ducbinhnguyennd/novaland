import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/widgets/item_card_taikhoan.dart';

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


  final _emailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  // TextEditingController emailEditingController = TextEditingController();
  // TextEditingController phoneEditingController = TextEditingController();
  TextEditingController userEditingController = TextEditingController();
  TextEditingController passwEditingController = TextEditingController();

  bool isEmailCorrect = false;
  String _username = '';
  // String _email = '';
  // String _phone = '';
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
  // ignore: non_constant_identifier_names
  Future<Response?> Register(
      String username) async {
    var dio = Dio();
    // final bool emailValid = RegExp(
    //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //     .hasMatch(emailEditingController.text);
    if (userEditingController.text == '' &&
        passwEditingController.text == '' 
      ) {
      print('chua co gi ca');
    } else {
      try {
        var response = await dio.post(
            'https://du-an-2023.vercel.app/userput/',
            data: {
              "username": username,
              // "gioitinh": gioitinh,
              // "email": email,
              // "phone": phone
            },
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
                // TextFormField(
                //   key: _emailKey,
                //   controller: emailEditingController,
                //   onChanged: (val) {
                //     doValidation(_emailKey, null);
                //     _email = val;
                //   },
                //   keyboardType: TextInputType.emailAddress,
                //   decoration: InputDecoration(
                //       enabledBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(color: Colors.black),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(color: Colors.deepPurple),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       labelText: "Email"),
                //   validator: (val) {
                //     if (val == null || val.isEmpty) {
                //       return 'nhap lai';
                //     }
                //     if (!RegExp(_emailRegex).hasMatch(val)) {
                //       return 'nhap dung dinh dang';
                //     }
                //     return null;
                //   },
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // TextFormField(
                //   key: _phoneKey,
                //   onChanged: (val) {
                //     doValidation(_phoneKey, null);
                //     _phone = val;
                //   },
                //   keyboardType: TextInputType.phone,
                //   maxLength: 10,
                //   decoration: InputDecoration(
                //       enabledBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(color: Colors.black),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(color: Colors.deepPurple),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       labelText: "So dien thoai"),
                //   validator: (val) {
                //     if (val == null || val.isEmpty) {
                //       return 'nhap lai';
                //     }
                //     if (val.length != 10) {
                //       return 'nhap du';
                //     }
                //     if (!val.startsWith('0')) {
                //       return 'Số điện thoại phải bắt đầu bằng số 0';
                //     }
                //     return null;
                //   },
                // ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: _gioiTinhList
                //       .map(
                //         (gender) => RadioListTile(
                //           title: Text(gender),
                //           groupValue: _gioitinh,
                //           value: gender,
                //           onChanged: (value) {
                //             setState(() {
                //               _gioitinh = value.toString();
                //             });
                //           },
                //         ),
                //       )
                //       .toList(),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     var alo = doValidation(null, _formKey);
                //     if (!RegExp(_emailRegex)
                //             .hasMatch(emailEditingController.text) &&
                //         phoneEditingController.text.length != 10) {
                //       print('errro');
                //     } else {
                //       Register(_username, _email, _gioitinh, _phone);
                //     }
                //   },
                //   style: ButtonStyle(
                //     backgroundColor: MaterialStateProperty.all<Color>(
                //         Colors.purple), // Màu nền tím
                //   ),
                //   child: Text('Lưu'),
                // ),
                ElevatedButton(
                  onPressed: () {
                 
                      Register(_username);
                    
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.purple), // Màu nền tím
                  ),
                  child: Text('Lưu'),
                ),
                ItemCardTaiKhoanWidget(title: 'Đổi mật khẩu', onTap: () {})
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
