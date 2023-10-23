import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loginapp/widgets/item_card_stk.dart';

class ThemTienThach extends StatefulWidget {
  const ThemTienThach({super.key});
  static const routeName = 'themtienthach';

  @override
  State<ThemTienThach> createState() => _ThemTienThachState();
}

class _ThemTienThachState extends State<ThemTienThach> {
  List<String> names = [];
  List<String> imageList = [
    'assets/images/tcb.jpg',
    'assets/images/vtb.jpg',
    'assets/images/bidv.jpg',
    'assets/images/acb.png',
    'assets/images/mbb.png',
    'assets/images/mbb.png',
  ];

  final _storage = const FlutterSecureStorage();

  Future<void> fetchData() async {
    var dio = Dio();
    try {
      var response = await dio.get(
        'https://ttg5androidapi.g5manhua.com/api/newstory/getlistnganhang',
        options: Options(
          headers: {
            'content-type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.statusCode == 200) {
        var responseData = response.data;
        if (responseData['success']) {
          var dataList = responseData['data'];
          if (dataList is List && dataList.isNotEmpty) {
            setState(() {
              names = dataList.map((item) => item['name'] as String).toList();
            });
          }
        } else {
          print('API request failed');
        }
      } else {
        print('API response status: ${response.statusCode}');
      }
    } catch (e) {
      print('API request error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Thanh toán'),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        height: 500,
        child: ListView.builder(
          itemCount: names.length,
          itemBuilder: (context, index) {
            return ItemCardStk(
                title: names[index], onTap: () {}, imagestk: imageList[index]);
          },
        ),
      ),
    );
  }
}
