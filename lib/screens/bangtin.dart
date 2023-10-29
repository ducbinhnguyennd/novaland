import 'package:flutter/material.dart';
import 'package:loginapp/widgets/item_bangtin.dart';

import '../constant/colors_const.dart';

class BangTinScreen extends StatefulWidget {
  const BangTinScreen({Key? key}) : super(key: key);
  static const routeName = 'bangtin';
  @override
  State<BangTinScreen> createState() => _BangTinScreenState();
}

class _BangTinScreenState extends State<BangTinScreen>
    with SingleTickerProviderStateMixin {
  int selectedTabIndex = 0;

  void _changeTab(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  final List<String> imageList = [
    'https://cdn.popsww.com/blog/sites/2/2022/03/truyen-tranh-ngon-tinh-hoc-duong-1280x720.jpg',
    'https://chancanvas.com/wp-content/uploads/2022/09/306089180_194933922891775_7621195946673248357_n.jpg',
    'https://phantich.com.vn/wp-content/uploads/2022/03/Chi-pheo.png',
  ];
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        centerTitle: true,
        backgroundColor: ColorConst.colorPrimary50,
        elevation: 0,
        title: Text(
          'Bảng tin',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(0),
        children: [
          Container(
            color: ColorConst.colorPrimary50,
            height: MediaQuery.of(context).size.height / 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 10, 25.0, 25.0),
              child: Stack(
                children: [
                  SizedBox(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: imageList.length,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25)),
                          child: Image.network(
                            imageList[index],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(imageList.length, (index) {
                        return Container(
                          width: 10,
                          height: 10,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 0.5),
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? ColorConst.colorPrimary30
                                : Colors.transparent,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => _changeTab(0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: selectedTabIndex == 0
                          ? ColorConst.colorPrimary50
                          : Colors.grey[350],
                    ),
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'All',
                      style: TextStyle(
                          color: selectedTabIndex == 0
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => _changeTab(1),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: selectedTabIndex == 1
                          ? ColorConst.colorPrimary50
                          : Colors.grey[350],
                    ),
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Thăng cấp',
                      style: TextStyle(
                          color: selectedTabIndex == 1
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => _changeTab(2),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: selectedTabIndex == 2
                          ? ColorConst.colorPrimary50
                          : Colors.grey[350],
                    ),
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Top react',
                      style: TextStyle(
                          color: selectedTabIndex == 2
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => _changeTab(3),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: selectedTabIndex == 3
                          ? ColorConst.colorPrimary50
                          : Colors.grey[350],
                    ),
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Nhóm dịch',
                      style: TextStyle(
                          color: selectedTabIndex == 3
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (selectedTabIndex == 0)
            Column(
              children: [ItemBangTin(), ItemBangTin()],
            )
          else if (selectedTabIndex == 1)
            Text('Bảng tin 2')
          else if (selectedTabIndex == 2)
            Text('Bảng tin 3')
          else if (selectedTabIndex == 3)
            Text('Bảng tin 4')
        ],
      ),
    );
  }
}
// class _BangTinScreenState extends State<BangTinScreen>
//     with SingleTickerProviderStateMixin {
//   bool isExpanded1 = false;
//   bool isSlided1 = false;
//   late AnimationController _animationController;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 300),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _handleSlideStart(DragStartDetails details) {
//     setState(() {
//       isSlided1 = true;
//     });
//   }

//   void _handleSlideUpdate(DragUpdateDetails details) {
//     if (details.primaryDelta! < 0) {
//       _animationController.value -= details.primaryDelta! / context.size!.width;
//     }
//   }

//   void _handleSlideEnd(DragEndDetails details) {
//     if (_animationController.value < 0.5) {
//       _animationController.reverse().then((value) {
//         setState(() {
//           isSlided1 = false;
//         });
//       });
//     } else {
//       _animationController.forward();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: ColorConst.colorPrimary50,
//         title: Text('Thế giới'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   isExpanded1 = !isExpanded1;
//                 });
//               },
//               onHorizontalDragStart: _handleSlideStart,
//               onHorizontalDragUpdate: _handleSlideUpdate,
//               onHorizontalDragEnd: _handleSlideEnd,
//               behavior: HitTestBehavior.deferToChild,
//               child: Stack(
//                 children: [
//                   Container(
//                     // Explicitly set the width for SlideTransition
//                     width: MediaQuery.of(context).size.width,
//                     child: AnimatedBuilder(
//                       animation: _animationController,
//                       builder: (context, child) {
//                         return Container(
//                           width: isSlided1
//                               ? MediaQuery.of(context).size.width *
//                                   (1 - _animationController.value * 0.3)
//                               : MediaQuery.of(context).size.width,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: isExpanded1 ? ColorConst.colorPrimary : Colors.grey,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.all(5.0),
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                         ),
//                                         child: Image.asset(
//                                           AssetsPathConst.logo,
//                                           height: 30,
//                                         ),
//                                       ),
//                                     ),
//                                     Column(
//                                       children: [
//                                         Text(
//                                           'Notification Title',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 17),
//                                         ),
//                                         Text(
//                                           'Here’s notification text.',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 13),
//                                         ),
//                                       ],
//                                     ),
//                                     Spacer(),
//                                     AnimatedOpacity(
//                                       opacity: isSlided1 ? 0.0 : 1.0,
//                                       duration: Duration(milliseconds: 300),
//                                       child: Text(
//                                         '34 phút trước',
//                                         style: TextStyle(
//                                             color: Colors.white, fontSize: 13),
//                                       ),
//                                     ),
//                                     SizedBox(width: 10),
//                                   ],
//                                 ),
//                               ),
//                               if (isExpanded1)
//                                 Container(
//                                   height: 150,
//                                   width:  MediaQuery.of(context).size.width,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(60),
//                                     color: Colors.blue,
//                                   ),
//                                   child: Image.asset(
//                                     AssetsPathConst.backgroundStoryDetail,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   if (isSlided1)
//                     Positioned(
//                       right: 0,
//                       top: 0,
//                       bottom: 0,
//                       child: Container(
//                         width: 50,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Colors.red,
//                         ),
//                         alignment: Alignment.center,
//                         child: Icon(Icons.delete, color: Colors.white),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
          
//         ],
//       ),
//     );
//   }
// }
