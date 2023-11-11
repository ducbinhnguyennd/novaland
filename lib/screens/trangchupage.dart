import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/constant/asset_path_const.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/screens/category_screen.dart';
import 'package:loginapp/screens/search_screen.dart';
import 'package:loginapp/widgets/item_trangchu.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class ItemCarousel {
  final String id;
  final String image;

  ItemCarousel({
    required this.id,
    required this.image,
  });
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int _current = 0;
  bool _isLoading = true;

  final List<ItemCarousel> itemList = [
    ItemCarousel(
        id: '',
        image:
            'https://toptruyentranh.net/wp-content/uploads/2021/04/top-9-truyen-tranh-ngon-tinh-hay-nhat.png'),
    ItemCarousel(
        id: '',
        image:
            'https://307a0e78.vws.vegacdn.vn/view/v2/image/img.media/ngon-tinh-sac.jpg'),
    ItemCarousel(
        id: '',
        image:
            'https://canhrau.com/wp-content/uploads/2022/01/truyen-tranh-ngon-tinh-thanh-xuan-vuon-truong-trung-quoc-hinh-2.png'),
  ];

  final List<TheloaiItem> theloaiItems = [
    TheloaiItem(
      image: '${AssetsPathConst.theloai}1.png',
      theloaiID: '649d61870631b61a30ca3238',
      theloaiName: 'Ngôn Tình',
      initialTabIndex: 0,
    ),
    TheloaiItem(
      image: '${AssetsPathConst.theloai}2.png',
      theloaiID: '649d61c00631b61a30ca324d',
      theloaiName: 'Vườn Trường',
      initialTabIndex: 1,
    ),
    TheloaiItem(
      image: '${AssetsPathConst.theloai}4.png',
      theloaiID: '649d61ec0631b61a30ca325a',
      theloaiName: 'Bách Hợp',
      initialTabIndex: 3,
    ),
    TheloaiItem(
      image: '${AssetsPathConst.theloai}3.png',
      theloaiID: '649d634e0631b61a30ca33ba',
      theloaiName: 'Đam Mỹ',
      initialTabIndex: 2,
    )
  ];
_theloai() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14.0, 14.0, 14.0, 0),
      child: GridView.builder(
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Số cột bạn muốn hiển thị
          crossAxisSpacing: 10,
          //  mainAxisSpacing: 10,
          childAspectRatio: 3,
        ),
        itemCount: theloaiItems.length,
        itemBuilder: (context, index) {
          return !_isLoading
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300],
                    ),
                    width: 550,
                  ),
                )
              : InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => FourCategory(
                    //             theloaiID: tlngon,
                      
                    //             isShowFilterStories: false,
                    //             initialTabIndex:
                    //                 theloaiItems[index].initialTabIndex,
                    //           )),
                    // );

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => StoryCategoryScreen(
                    //       theloaiID: tlngon,
                    //       trangthai: -1,
                    //       sort: 1,
                    //       isShowFilterStories: false,
                    //       initialTabIndex: theloaiItems[index].initialTabIndex,
                    //     ),
                    //   ),
                    // );

                    // Navigator.of(context).pushReplacement(
                    //   PageRouteBuilder(
                    //     transitionDuration: Duration(milliseconds: 500),
                    //     pageBuilder: (context, animation, secondaryAnimation) => MainScreen(
                    //       initialTabIndex: 3,
                    //       theloaiID: theloaiItems[index].theloaiID,
                    //       theloaiName: theloaiItems[index].theloaiName,
                    //     ),
                    //     transitionsBuilder:
                    //         (context, animation, secondaryAnimation, child) {
                    //       return FadeTransition(
                    //         opacity: animation,
                    //         child: child,
                    //       );
                    //     },
                    //   ),
                    // );
                  },
                  child: Container(
                    // height: 43,
                    // width:100,

                    child: Image.asset(
                      theloaiItems[index].image,
                      // fit: BoxFit.fitHeight,
                      // cacheHeight: 200,
                      cacheWidth: 550,
                    ),
                  ),
                );
        },
      ),
    );
  }
  Widget Search() {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Row(      
        children: [
          Expanded(
            flex: 9,
            child: Container(
              height: 40,
              
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorConst.colorPrimary),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('Tìm kiếm truyện'),
                      Spacer(),
                      Icon(
                        Icons.search,
                        color: ColorConst.colorPrimary50,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(onPressed: (){
             
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CategoriesScreen(),
                              ),
                            );
                          
            }, icon: Icon(Icons.category)),
          )
        ],
      ),
    );
  }
  
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    print('abc');
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFD1D3), Colors.white],
            stops: [0.0, 0.4],
          ),
        ),
        child: ListView(
          // shrinkWrap: true,
          children: [
            Search(),
           SizedBox(
            height: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: itemList.length,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),

                              child: Image.network(
                                itemList[index].image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(itemList.length, (index) {
                      return Container(
                        width: 10,
                        height: 10,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorConst.colorPrimary80, width: 0.5),
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? ColorConst.colorPrimary30
                              : Colors.transparent,
                        ),
                      );
                    }),
                  ),
          _theloai(),
          
            ItemTrangChu()
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
class TheloaiItem {
  final String image;
  final String theloaiID;
  final String theloaiName;
  final int initialTabIndex;

  TheloaiItem({
    required this.image,
    required this.theloaiID,
    required this.theloaiName,
    required this.initialTabIndex,
  });
}
