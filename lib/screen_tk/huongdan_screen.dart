import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:loginapp/widgets/item_card_huongdan.dart';

class HuongDanScreen extends StatefulWidget {
  const HuongDanScreen({super.key});
  static const routeName = 'huongdan_screen';

  @override
  State<HuongDanScreen> createState() => _HuongDanScreenState();
}

class _HuongDanScreenState extends State<HuongDanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: Text('Hướng dẫn'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const ItemHuongdan(
                title: 'Tiên thạch là gì, làm sao để Thêm/Nạp tiên thạch?',
                titleSmall:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
            ItemHuongdan(
                title: 'Giới thiệu Vip-Reader',
                titleSmall:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
            ItemHuongdan(
                title: 'Điều khoản dịch vụ',
                titleSmall:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
            ItemHuongdan(
                title: 'Về Bản Quyền',
                titleSmall:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
            ItemHuongdan(
                title: 'Bảo Mật Riêng Tư',
                titleSmall:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
            ItemHuongdan(
                title: 'Liên hệ',
                titleSmall:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.')
          ],
        ),
      ),
    );
  }
}
