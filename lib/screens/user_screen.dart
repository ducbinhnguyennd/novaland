// user_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/user_model.dart';
import 'package:loginapp/model/user_model2.dart';
import 'package:loginapp/user_Service.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final ApiUser apiService = ApiUser();
  Data? currentUser;
  late Future<UserModel> futureUserData;

  _loadUser() {
    UserServices us = UserServices();
    us.getInfoLogin().then((value) {
      if (value != "") {
        setState(() {
          currentUser = Data.fromJson(jsonDecode(value));
          futureUserData = apiService.fetchUserData(currentUser?.user[0].id ?? '');
        });
      } else {
        setState(() {
          currentUser = null;
        });
      }
    }, onError: (error) {
      // Xử lý lỗi khi lấy thông tin người dùng
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
      appBar: AppBar(
        title: Text('User Screen'),
      ),
      body: FutureBuilder<UserModel>(
        future: futureUserData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final userData = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('User ID: ${userData.userId}'),
                Text('Username: ${userData.username}'),
                Text('Role: ${userData.role}'),
                Text('Coin: ${userData.coin}'),
              ],
            );
          }
        },
      ),
    );
  }
}
