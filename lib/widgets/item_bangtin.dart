import 'package:flutter/material.dart';
import 'package:loginapp/constant/asset_path_const.dart';
import 'package:loginapp/constant/colors_const.dart';

class ItemBangTin extends StatefulWidget {
  const ItemBangTin({Key? key}) : super(key: key);

  @override
  _ItemBangTinState createState() => _ItemBangTinState();
}

class _ItemBangTinState extends State<ItemBangTin> {
  bool isFollowing = false;
  bool isLike = false;

  void toggleFollowStatus() {
    setState(() {
      isFollowing = !isFollowing;
    });
  }

  void toggleLike() {
    setState(() {
      isLike = !isLike;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: Text('Alo'),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tên nhóm dịch',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Ngày đăng',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: toggleFollowStatus,
                  child: Row(
                    children: [
                      Image.asset(
                        isFollowing
                            ? AssetsPathConst.icodafollow
                            : AssetsPathConst.icofollow,
                        height: 20,
                      ),
                      Text(
                        isFollowing ? ' Đã theo dõi' : ' Theo dõi',
                        style: TextStyle(
                          color: isFollowing ? ColorConst.colorPrimary50 : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 15.0, 15.0),
            child: Text(
                'Bộ truyện Mao Sơn Tróc Quỷ Sơn chính thức end phần 1, team đã up ngang chap và cùng đợi phần 2 nhé.',
                style: TextStyle(fontSize: 15)),
          ),
          Row(
            children: [
              Icon(Icons.favorite_outlined,
                  color: ColorConst.colorPrimary50, size: 25),
              Text(' 126')
            ],
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: toggleLike,
                      child: Icon(
                          isLike ? Icons.favorite : Icons.favorite_border,
                          color: isLike
                              ? ColorConst.colorPrimary50
                              : Colors.grey[350],
                          size: 25),
                    ),
                    Text(' Tim')
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.chat, size: 25, color: Colors.grey[350]),
                    Text(' Bình luận')
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 25, color: Colors.grey[350]),
                    Text(' Nhắn tin')
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.report, size: 25, color: Colors.grey[350]),
                    Text(' Report')
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: ColorConst.colorPrimary80,
            thickness: 5,
          ),
        ],
      ),
    );
  }
}
