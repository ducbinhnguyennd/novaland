import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/lichsuthanhtoan_model.dart';

class LichSuGiaoDich extends StatefulWidget {
   LichSuGiaoDich({super.key,  required this.userId});
  static const routeName = 'lichsugiaodich';
  String userId;
  @override
  State<LichSuGiaoDich> createState() => _LichSuGiaoDichState();
}

class _LichSuGiaoDichState extends State<LichSuGiaoDich> {
   final PaymentApi _paymentApi = PaymentApi();
  late Future<List<PaymentHistory>> _paymentHistory;

  @override
  void initState() {
    super.initState();
    _paymentHistory = _paymentApi.getPaymentHistory(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử thanh toán'),
        backgroundColor: ColorConst.colorPrimary50,
      ),
      body: FutureBuilder<List<PaymentHistory>>(
        future: _paymentHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Đã xảy ra lỗi: ${snapshot.error}');
          } else if ( snapshot.data!.isEmpty  ) {
            return Center(child: Text('Chưa có lịch sử thanh toán'));
          } else {
            final paymentHistory = snapshot.data;
            return ListView.builder(
              itemCount: paymentHistory?.length,
              itemBuilder: (context, index) {
                final history = paymentHistory?[index];
                return ListTile(
                  title: Text('Total Amount: ${history?.totalAmount.toStringAsFixed(2)} ${history?.currency}'),
                  subtitle: Text('Coin: ${history?.coin}, Date: ${history?.date}, Success: ${history?.success}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
