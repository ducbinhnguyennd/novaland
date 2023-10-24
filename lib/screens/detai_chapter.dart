import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/common_service.dart';
import 'package:loginapp/constant/strings_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/detailtrangchu_model.dart';
import 'package:loginapp/routes.dart';
import 'package:loginapp/user_Service.dart';

class DetailChapter extends StatefulWidget {
  final String chapterId;
  final String storyName;
  final String storyId;
  const DetailChapter({super.key, required this.chapterId, required this.storyName, required this.storyId});

  @override
  State<DetailChapter> createState() => _DetailChapterState();
}

class _DetailChapterState extends State<DetailChapter> {
  late Future<List<String>> chapterDetail;
  bool _isShowBar = true;
  bool setStatelaidi = true;
   ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
      UserServices us = UserServices();
us.addChuongVuaDocCuaTruyen(widget.chapterId, widget.storyName , widget.storyId);
    // _scrollController.addListener(_scrollListener);
    chapterDetail = ChapterDetail.fetchChapterImages(widget.chapterId);
  }
    @override
  void dispose() {
    
    super.dispose();
    _scrollController.dispose();
  }
_buildNavbar() {
    return AppBar(
      // toolbarHeight: _isShowBar ? 100 : 0.0,
      title: Text(
        widget.storyName ?? 'Tanvlog',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 10.0,
              offset: Offset(1.0, 1.0),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.5),
              Colors.transparent,
              Colors.transparent,
            ],
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop(setStatelaidi);
        },
      ),
      
      
    );
  }
  void _showToast(String ms) {
    if (ms.contains(StringConst.textyeucaudangnhap)) {
      // update count show user need login: only first show toast need login, after will show snack bar to go to login screen,
      // show snack bar login here,
      CommonService.showSnackBar(StringConst.textyeucaudangnhap, context, () {
        // go to login screen
        RouteUtil.redirectToLoginScreen(context);
      });
      return;
    }

    // SHOW TOAST
    if (!mounted) return;
    CommonService.showToast(ms, context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: ColorConst.colorPrimary50,
      //   title: Text('Chapter ${widget.storyName}'),
      // ),
      body: Stack(
        children: [
          
          FutureBuilder<List<String>>(
            future: chapterDetail,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                if (snapshot.hasData) {
                  List<String> imageUrls = snapshot.data!;
                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: ListView.builder(
                      // controller: _scrollController,
                      physics: NeverScrollableScrollPhysics(),
                      // scrollDirection: Axis.vertical,
                      itemCount: imageUrls.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Image.memory(base64Decode(imageUrls[index]),fit: BoxFit.cover, );
                      },
                    ),
                  );
                } else {
                  return Center(child: Text('No data available.'));
                }
              }
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              height: _isShowBar
                  ? 56.0 + MediaQuery.of(context).viewPadding.top
                  : 0.0,
              duration: const Duration(milliseconds: 200),
              child: _buildNavbar(),
            ),
          ),
        ],
      ),
    );
  }
  ScrollDirection? _previousScrollDirection;
void clearCacheMemory() {
    ImageCache _imageCache = PaintingBinding.instance.imageCache;
    imageCache.clear();
    _imageCache.clearLiveImages();
  }

  void _scrollListener() {
    final currentScrollDirection =
        _scrollController.position.userScrollDirection;

    if (_previousScrollDirection != currentScrollDirection) {
      setState(() {
        _previousScrollDirection = currentScrollDirection;
        if (currentScrollDirection == ScrollDirection.forward) {
          _isShowBar = true;
          print('cuộn lên nè');
        } else if (currentScrollDirection == ScrollDirection.reverse) {
          _isShowBar = false;
          print('cuộn xuống nè');
        }
      });
    }
  }
}
