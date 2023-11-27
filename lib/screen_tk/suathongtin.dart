import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/model/user_model.dart';
import 'package:loginapp/user_Service.dart';

class SuaThongTin extends StatefulWidget {
  const SuaThongTin({super.key});
  static const routeName = 'suathongtin';

  @override
  State<SuaThongTin> createState() => _SuaThongTinState();
}

class _SuaThongTinState extends State<SuaThongTin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConst.colorPrimary50,
          centerTitle: true,
          title: const Text('Thay đổi ảnh đại diện'),
        ),
        body: Center(
          child: Text('Đang cập nhật...'),
        ));
  }
}
