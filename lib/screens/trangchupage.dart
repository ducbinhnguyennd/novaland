import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
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

  Widget Search() {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width,
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
    );
  }

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
            CarouselSlider(
              options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  autoPlayInterval: Duration(seconds: 2),
                  onPageChanged: (index, reason) {
                    // setState(() {
                    //   _current = index;
                    // });
                  }),
              items: itemList.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blue,
                      ),
                      child: Image.network(
                        item.image,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: itemList.map((item) {
                int index = itemList.indexOf(item);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? ColorConst.colorPrimary30
                        : Colors.grey,
                  ),
                );
              }).toList(),
            ),
            ItemTrangChu()
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
