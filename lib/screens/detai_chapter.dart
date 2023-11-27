import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart' as dom;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:html/parser.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/common_service.dart';
import 'package:loginapp/constant/double_x.dart';
import 'package:loginapp/constant/strings_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/detail_chapter.dart';
import 'package:loginapp/model/user_model.dart';
import 'package:loginapp/routes.dart';
import 'package:loginapp/user_Service.dart';

class DetailChapter extends StatefulWidget {
  final String chapterId;
  String? storyName;
  final String storyId;
  String? viporfree;
  String? idUser;
  DetailChapter(
      {super.key,
      required this.idUser,
      required this.chapterId,
      this.storyName,
      required this.storyId,
      this.viporfree});

  @override
  State<DetailChapter> createState() => _DetailChapterState();
}

class _DetailChapterState extends State<DetailChapter> {
  ComicChapter? chapterDetail;
  bool _isShowBar = true;
  bool setStatelaidi = true;
  ScrollController _scrollController = ScrollController();

  Data? currentUser;
  _loadUser() {
    UserServices us = UserServices();
    us.getInfoLogin().then((value) {
      if (value != "") {
        setState(() {
          currentUser = Data.fromJson(jsonDecode(value));
          ChapterDetail.fetchChapterImages(
                  widget.chapterId, currentUser?.user[0].id ?? '')
              .then((value) {
            setState(() {
              chapterDetail = value;
            });
          });
        });
      } else {
        setState(() {
          currentUser = null;
        });
      }
    }, onError: (error) {
      if (kDebugMode) {
        print(
            '_alexTR_logging_ : SettingPage: _loadUser: error: ${error.toString()}');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUser();

    UserServices us = UserServices();
    print('alo123 ${chapterDetail?.id}');
    us.addChuongVuaDocCuaTruyen(
        widget.chapterId, chapterDetail?.name ?? 'lỗi', widget.storyId);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> _goToNewChap(String chapId, String userId) async {
    print('object $chapId');
    await ChapterDetail.fetchChapterImages(chapId, userId).then((value) {
      setState(() {
        chapterDetail = value;
        // if (chapterDetail?.nextChap?.vipOrFree == 'vip') {
        //   widget.viporfree = 'vip';
        // }
        widget.viporfree = chapterDetail?.viporfree ?? 'vip';
        UserServices us = UserServices();
        print('alo123 ${chapterDetail?.id}');
        us.addChuongVuaDocCuaTruyen(chapterDetail?.id ?? widget.chapterId,
            chapterDetail?.name ?? 'lỗi', widget.storyId);
        // _scrollController.addListener(_scrollListener);
      });
    });
  }

  Widget _buildBottomBar(ComicChapter? chap) {
    final bool isFirstChapter = chap?.prevChap == null;
    final bool isNextChapter = chap?.nextChap == null;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          color: ColorConst.colorBgNovelBlack.withOpacity(0.7),
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
                        isFirstChapter
                            ? _showToast('Bạn đang đọc chap đầu tiên')
                            : _goToNewChap(chapterDetail?.prevChap?.id ?? '-1',
                                currentUser?.user[0].id ?? '');
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
                        isNextChapter
                            ? _showToast('Bạn đang đọc chap mới nhất')
                            : _goToNewChap(chapterDetail?.nextChap?.id ?? '-1',
                                currentUser?.user[0].id ?? '');
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
        chapterDetail?.name ?? 'Đang tải...',
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
        // print(imageUrls);
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
        // print(imageUrls);
      }
    }
    return imageUrls;
  }

  void bychapterlock() async {
    final apiUrl =
        // 'https://mangaland.site/purchaseChapter/${currentUser!.user[0].id}/${widget.chapterId}';
        'https://du-an-2023.vercel.app/purchaseChapter/${currentUser!.user[0].id}/${chapterDetail?.id}';

    try {
      final response = await dio.post(apiUrl);
      if (response.statusCode == 200) {
        setState(() {
          widget.viporfree = 'free';
        });
      }
    } catch (e) {
      _showToast('Bạn không đủ xu, vui lòng nạp thêm');
    }
  }

  Widget _buildVipChapterBodyPartLock() {
    double height = AppBar().preferredSize.height;
    if (height <= 0) {
      height = DoubleX.kPaddingSizeHuge_1XX;
    }
    return Center(
      child: Container(
        padding: EdgeInsets.fromLTRB(
            DoubleX.kPaddingSizeLarge,
            height + MediaQuery.of(context).padding.top,
            DoubleX.kPaddingSizeLarge,
            DoubleX.kPaddingSizeZero),
        alignment: Alignment.topCenter,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          cacheExtent: 0,
          padding: EdgeInsets.only(bottom: 30),
          shrinkWrap: true,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  StringConst.textThongBao,
                  style: TextStyle(
                    fontSize: DoubleX.kFontSizeTiny_1XXX,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: DoubleX.kPaddingSizeMedium_1XXX,
                  ),
                ),
                const Text(
                  StringConst.textThongBaoChapVip,
                  style: TextStyle(fontSize: DoubleX.kFontSizeTiny_1X1X),
                ),
                Padding(
                  padding: EdgeInsets.only(top: DoubleX.kPaddingSizeLarge_1XX),
                  child: Wrap(
                    children: [
                      Text(
                        StringConst.suggestUsersDoMission,
                        style: TextStyle(
                            fontSize: DoubleX.kFontSizeTiny_1X1X,
                            fontWeight: FontWeight.bold,
                            color: ColorConst.colorDanger),
                      )
                    ],
                  ),
                ),
                const Divider(),
                const SizedBox(
                  height: DoubleX.kPaddingSizeLarge,
                ),
                GestureDetector(
                  onTap: () async {
                    bychapterlock();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Colors.grey,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lock,
                            color: ColorConst.colorPrimaryText,
                          ),
                          const SizedBox(
                            width: DoubleX.kPaddingSizeTiny,
                          ),
                          Text("Mở Khóa )",
                              style: const TextStyle(
                                color: ColorConst.colorPrimaryText,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: DoubleX.kPaddingSizeLarge,
                ),
                const Divider(
                  height: 2,
                  thickness: 2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyChapter(String sChapContent) {
    print('${widget.viporfree}');

    // chap is vip
    if (widget.viporfree == 'vip') {
      _isShowBar = true;
      return Stack(
        children: [_buildVipChapterBodyPartLock()],
      );
    } else {
      return _buildChapterBodyPartNormal(sChapContent);
    }
  }

  Widget _buildChapterBodyPartNormal(String sChapContent) {
    // List<String> imageUrls = _extractImageUrlsFromHtml(sChapContent);
    // List<String> imageUrls = extractImageUrlsFromHtml(Globals.urlImgCode);
    List<String> imageUrls = _extractImageUrlsFromHtml(sChapContent);
    // List<String> imageUrls = extractImageUrlsFromHtml(Globals.urlImgCode);

    return Container(
        height: MediaQuery.of(context).size.height,
        child: imageUrls.isNotEmpty
            ? InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  setState(() {});
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
                                          : MediaQuery.of(context).size.height /
                                              4),
                                  child: CircularProgressIndicator.adaptive(),
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
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            // controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            // scrollDirection: Axis.vertical,
            itemCount: chapterDetail?.images.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              // print('${chapterDetail?.images[index]}');
              return _buildBodyChapter(chapterDetail?.images[index] ?? '');
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
              child: _buildBottomBar(chapterDetail),
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
