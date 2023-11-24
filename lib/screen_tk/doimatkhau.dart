import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = 'doimatkhau';
  final String userId;
   const ChangePasswordScreen(
      {Key? key,
     
    required this.userId
     })
      : super(key: key);
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newUsernameController = TextEditingController();

bool _isObscureOldPassword = true;
  bool _isObscureNewPassword = true;
   PasswordChangeService passwordChangeService = PasswordChangeService();
  void _handleChangePassword() async {
    final String userId = widget.userId; 
    final String oldPassword = oldPasswordController.text;
    final String newPassword = newPasswordController.text;
   
    


    if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
      try {
        await passwordChangeService.changePassword(userId, oldPassword, newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đổi mật khẩu thành công'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mật khẩu cũ của bạn không đúng'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng nhập đủ thông tin'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  void _handleUserName() async {
    final String userId = widget.userId; 
    final String newUsername = newUsernameController.text;

   
    


    if (newUsername.isNotEmpty) {
      try {
        await passwordChangeService.changeUsername(userId, newUsername);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đổi biệt danh khẩu thành công'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xảy ra lỗi'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng nhập đủ thông tin'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thay đổi thông tin'),
        backgroundColor: ColorConst.colorPrimary50,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: newUsernameController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Biệt danh mới',
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _handleUserName,
              child: Text('Thay đổi tên'),
            ),
             TextField(
              controller: oldPasswordController,
              obscureText: _isObscureOldPassword,
              decoration: InputDecoration(
                labelText: 'Mật khẩu cũ',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscureOldPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscureOldPassword = !_isObscureOldPassword;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: _isObscureNewPassword,
              decoration: InputDecoration(
                labelText: 'Mật khẩu mới',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscureNewPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscureNewPassword = !_isObscureNewPassword;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _handleChangePassword,
              child: Text('Thay đổi mật khẩu'),
            ),
          ],
        ),
      ),
    );
  }
}

