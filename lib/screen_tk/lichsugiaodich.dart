import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:loginapp/widgets/item_card_taikhoan.dart';

class LichSuGiaoDich extends StatefulWidget {
  const LichSuGiaoDich({super.key});
  static const routeName = 'lichsugiaodich';

  @override
  State<LichSuGiaoDich> createState() => _LichSuGiaoDichState();
}

class _LichSuGiaoDichState extends State<LichSuGiaoDich> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: const Text('Lịch sử giao dịch'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ItemCardTaiKhoanWidget(title: 'Lịch sử mua chương', onTap: () {}),
            ItemCardTaiKhoanWidget(
                title: 'Lịch sử thêm tiên thạch', onTap: () {}),
            ItemCardTaiKhoanWidget(title: 'Lịch sử ủng hộ', onTap: () {}),
            ItemCardTaiKhoanWidget(title: 'Lịch sử đề cử', onTap: () {}),
          ],
        ),
      ),
    );
  }
}
