import 'dart:convert';
import 'dart:io';
import 'package:html/dom.dart' as dom;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:html/parser.dart';
import 'package:loginapp/Globals.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/common_service.dart';
import 'package:loginapp/constant/strings_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/detail_chapter.dart';
import 'package:loginapp/model/detailtrangchu_model.dart';
import 'package:loginapp/routes.dart';
import 'package:loginapp/user_Service.dart';

class DetailChapter extends StatefulWidget {
  final String chapterId;
   String? storyName;
  final String storyId;
   DetailChapter({super.key, required this.chapterId,  this.storyName, required this.storyId});

  @override
  State<DetailChapter> createState() => _DetailChapterState();
}

class _DetailChapterState extends State<DetailChapter> {
  ComicChapter? chapterDetail;
  bool _isShowBar = true;
  bool setStatelaidi = true;
   ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
      UserServices us = UserServices();
us.addChuongVuaDocCuaTruyen(widget.chapterId, widget.storyName ?? 'loi' , widget.storyId);
    // _scrollController.addListener(_scrollListener);
    ChapterDetail.fetchChapterImages(widget.chapterId).then((value) {
      setState(() {
        chapterDetail = value;
      });
    });
  }
    @override
  void dispose() {
    
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> _goToNewChap(String chapId) async {
    
     await ChapterDetail.fetchChapterImages(
          chapId
        
      ).then((value) {
       
        setState(() {
          widget.storyName = 'doi duoc doi';
          chapterDetail = value;
        });
        
        
        
      });
  }

  Widget _buildBottomBar(ComicChapter? chap) {
    final bool isFirstChapter =
        chap?.prevChap == null;
    final bool isNextChapter = chap?.nextChap == null;

    return Stack(
      children: [
        Container(
          color: ColorConst.colorBgNovelBlack.withOpacity(0.7),
          // height: 56,
        ),
        SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Container(
                  height: double.infinity,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: Icon(
                        Icons.arrow_left,
                        color: isFirstChapter
                            ? ColorConst.colorWhite.withOpacity(0.5)
                            : Colors.black,
                        size: 20,
                      ),
                      onTap: () {
                        isFirstChapter ?_showToast('banj dang doc chap dau thien'):
                        _goToNewChap(chapterDetail?.prevChap?.id ?? '-1');
                        ;
                        // go to the previous chapter,
                      },
                    ),
                  ),
                ),
              ),
              
              Expanded(
                child: Container(
                  // width: 60,
                  height: double.infinity,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: Icon(
                        Icons.arrow_right,
                        color: isNextChapter
                            ? Colors.white.withOpacity(0.2)
                            : Colors.black87,
                        size: 20,
                      ),
                      onTap: () {
                        isNextChapter?
                        _showToast('ban dang doc chap moi nhat'):
                       _goToNewChap(chapterDetail?.nextChap?.id ?? '-1');
                       
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
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

  List<String> _extractImageUrlsFromHtml(String htmlString) {
    List<String> imageUrls = [];
    dom.DocumentFragment document = parseFragment(htmlString);
    List<dom.Element> imgElements = document.querySelectorAll('img');
    for (dom.Element imgElement in imgElements) {
      String imageUrl = imgElement.attributes['src'] ?? '...';
      if (imageUrl != null) {
        if (imageUrl.startsWith('http')) imageUrls.add(imageUrl);
        print(imageUrls);
      }
    }
    return imageUrls;
  }

  List<String> extractImageUrlsFromHtml(String htmlString) {
  List<String> imageUrls = [];
  dom.DocumentFragment document = parseFragment(htmlString);
  List<dom.Element> imgElements = document.querySelectorAll('img');
  for (dom.Element imgElement in imgElements) {
    String imageUrl = imgElement.attributes['src'] ?? '...';
    if (imageUrl != null) {
      imageUrls.add('https:$imageUrl');
      print(imageUrls);
    }
  }
  return imageUrls;
}
Widget _buildChapterBodyPartNormal(String sChapContent) {
    List<String> imageUrls = _extractImageUrlsFromHtml(sChapContent);
    // List<String> imageUrls = extractImageUrlsFromHtml(Globals.urlImgCode);

    return Container(
      child: imageUrls.isNotEmpty
          ? InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {
                setState(() {
                  
                });
              },
              child: SingleChildScrollView(
                        controller: _scrollController,
                        // physics: const CustomScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 0, top: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: List.generate(
                                imageUrls.length,
                                (index) => CachedNetworkImage(
                                  // filterQuality: FilterQuality.low,
                                  fit: BoxFit.fitWidth,
                                  width: MediaQuery.of(context).size.width,
                                  imageUrl: imageUrls[index],
                                  placeholder: (context, url) {
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: index < 5
                                                ? 120
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4),
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      ),
                                    );
                                  },
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      ),
            )
          : Container(
              color: Colors.red,
              height: 20,
            ),
    );
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
          
           ListView.builder(
             // controller: _scrollController,
             physics: AlwaysScrollableScrollPhysics(),
             // scrollDirection: Axis.vertical,
             itemCount: chapterDetail?.images.length,
             shrinkWrap: true,
             itemBuilder: (context, index) {
               print('thien de tien: ${chapterDetail?.images[index]}');
                return _buildChapterBodyPartNormal(chapterDetail?.images[index] ?? '');
             return SingleChildScrollView(
                        controller: _scrollController,
                        // physics: const CustomScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 0, top: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: List.generate(
                                chapterDetail?.images.length ?? 0,
                                (index) => CachedNetworkImage(
                                  // filterQuality: FilterQuality.low,
                                  fit: BoxFit.fitWidth,
                                  width: MediaQuery.of(context).size.width,
                                  imageUrl: (chapterDetail?.images[index] ?? '').replaceAll('\r', ''),
                                  placeholder: (context, url) {
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: index < 5
                                                ? 120
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4),
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      ),
                                    );
                                  },
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      );
              
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
           Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedContainer(
              height: _isShowBar ? 56.0 : 56,
              duration: const Duration(milliseconds: 200),
              child: _buildBottomBar(chapterDetail!),
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
