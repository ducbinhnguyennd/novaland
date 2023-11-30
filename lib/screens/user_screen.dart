import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/constant/asset_path_const.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/double_x.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/topUser_model.dart';
import 'package:loginapp/widgets/item_top_user.dart';

class BXHScreen extends StatefulWidget {
  @override
  _BXHScreenState createState() => _BXHScreenState();
}

class _BXHScreenState extends State<BXHScreen> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin{
  ApiTopUser apiService = ApiTopUser();
  late Future<List<TopUserModel>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = apiService.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Bảng Xếp Hạng'),
        backgroundColor: ColorConst.colorPrimary50,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AssetsPathConst.nen),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // buildTopUserItemWidget(),
          FutureBuilder(
            future: futureUsers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: ColorConst.colorPrimary120,));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<TopUserModel> topUserList =
                    snapshot.data as List<TopUserModel>;
                return Positioned(
                    bottom: 0,
            left: 0,
            right: 0,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          
                          children: [
                            Expanded(
                              flex: 3,
                              child: buildTopUserItemWidget(2, topUserList),
                            ),
                            Expanded(
                              flex: 3,
                              child: buildTopUserItemWidget(0, topUserList),
                            ),
                            Expanded(
                              flex: 3,
                              child: buildTopUserItemWidget(1, topUserList),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 10,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          height: Platform.isIOS ? MediaQuery.of(context).size.height / 2.5 : MediaQuery.of(context).size.height / 3.5,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(
                              DoubleX.kPaddingSizeMedium_1X,
                              DoubleX.kPaddingSizeLarge,
                              DoubleX.kPaddingSizeMedium_1X,
                              DoubleX.kPaddingSizeTiny_1X,
                            ),
                            itemCount: topUserList.length,
                            itemBuilder: (context, index) {
                              if (index < topUserList.length - 3) {
                                return TopCuongGiaItem(
                                    model: topUserList[index + 3],
                                    index: index + 3);
                              }
                              return null;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            },
          ),
       
        ],
      ),
    );
  }

  Widget buildTopUserItemWidget(int index, List<TopUserModel> topUserList) {
    const widthAvatar = DoubleX.kLayoutHeightTiny_1XX;
    String levelImage;

    if (index == 0) {
      levelImage = AssetsPathConst.khunglevel1;
    } else if (index == 1) {
      levelImage = AssetsPathConst.khunglevel4;
    } else {
      levelImage = AssetsPathConst.khunglevel2;
    }

    return Column(
      children: [
        Text(
          'Top ${index + 1}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(2, 2),
                color: Colors.black,
                blurRadius: 3,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
             topUserList[index].avatar =='' ? Container(
                height: widthAvatar * 1.5,
                width: widthAvatar * 1.5,
                decoration: BoxDecoration(
                  color: Colors.red,
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.17),
                      blurRadius: 10,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(widthAvatar * 1.5),
                ),
                child:   Center(
                  child: Text(
                    topUserList[index].username.toString().substring(0, 1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: widthAvatar,
                      color: ColorConst.colorBackgroundStory,
                    ),
                  ),
                )
      ): Container(
        height: widthAvatar * 1.5,
                width: widthAvatar * 1.5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: MemoryImage(base64Decode(topUserList[index].avatar)),
            fit: BoxFit.cover,
          ),
        ),),
              
              Image.asset(
                levelImage,
                height: widthAvatar * 1.5 + 20,
                width: widthAvatar * 1.5 + 20,
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFdeeefe),
                Color(0xFFf0e1fb),
                Color(0xFFffd5ed),
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 10,
                offset: Offset(0, 0),
                spreadRadius: 0,
              ),
            ],
          ),
          height: index == 0
              ? Platform.isIOS
                  ? 150
                  : 120
              : index == 1
                  ? Platform.isIOS
                      ? 120
                      : 90
                  : Platform.isIOS
                      ? 80
                      : 50,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              children: [
                Text(topUserList[index].username, style: TextStyle(fontWeight: FontWeight.w600),),
                Text('Xu: ${topUserList[index].coin.toString()}'),
              ],
            ),
          ),
        ),
      ],
    );
  }
  @override
  bool get wantKeepAlive => true;
}
