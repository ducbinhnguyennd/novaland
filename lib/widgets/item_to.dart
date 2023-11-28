import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/common_service.dart';
import 'package:loginapp/constant/strings_const.dart';
import 'package:loginapp/model/user_model.dart';
import 'package:loginapp/routes.dart';
import 'package:loginapp/screens/detail_mangan.dart';
import 'package:loginapp/user_Service.dart';

class ItemTo extends StatefulWidget {
  final String id;
  final String image;
  final String name;
  final String sochap;

  ItemTo(
      {Key? key,
      required this.id,
      required this.image,
      required this.name,
      required this.sochap});

  @override
  _ItemToMoiState createState() => _ItemToMoiState();
}

class _ItemToMoiState extends State<ItemTo> {
  Data? currentUser;
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
      print('loi cmnr');
    });
  }

  @override
  void initState() {
    super.initState();

    _loadUser();
  }

  void _showToast(String msg) {
    if (msg.contains(StringConst.textyeucaudangnhap)) {
      // update count show user need login: only first show toast need login, after will show snack bar to go to login screen,
      // show snack bar login here,
      CommonService.showSnackBar(StringConst.textyeucaudangnhap, context, () {
        // go to login screen
        RouteUtil.redirectToLoginScreen(context);
      });
      return;
    }
    // SHOW TOAST
    CommonService.showToast(msg, context);
  }

  @override
  Widget build(BuildContext context) {
    final widthS = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        // height: widthS * 6 / 8,
        child: GestureDetector(
          onTap: () {
            if (currentUser != null && currentUser!.user != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MangaDetailScreen(
                      mangaId: widget.id, storyName: widget.name),
                ),
              );
            } else {
              _showToast(StringConst.textyeucaudangnhap);
            }
          },
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: widget.image,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight: Radius.circular(20)),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: 155,
                ),
                placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                  color: ColorConst.colorPrimary50,
                )), // Hiển thị khi đang tải ảnh
                errorWidget: (context, url, error) =>
                    Icon(Icons.error), // Hiển thị khi có lỗi tải ảnh
              ),
              Container(
                width: double.infinity,
                height: 40,
                child:  Column(
                children: [
                  Text(widget.name,
                      style: TextStyle(fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text('Chapter ${widget.sochap}')
                ],
              ),
                decoration: BoxDecoration(
                    color: ColorConst.colorPrimary120,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
