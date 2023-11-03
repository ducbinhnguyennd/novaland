import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/user_model.dart';
import 'package:loginapp/user_Service.dart';

class ThemTienThach extends StatefulWidget {
  static const routeName = 'themtienthach';

  @override
  _ThemTienThachState createState() => _ThemTienThachState();
}

class _ThemTienThachState extends State<ThemTienThach> {
  Data? currentUser;
   _loadUser() {
    UserServices us = UserServices();
    us.getInfoLogin().then((value) {
    
      if (value != "") {
        setState(() {
          currentUser = Data.fromJson(jsonDecode(value));
        });
      } else {
        setState(() {
          currentUser = null;
        });
      }
    }, onError: (error) {
     
    }).then((value) async{
       
          // _sendPaymentData()
      
    });
  }
 Future<void> _sendPaymentData(String userId, double amount, String currency) async {
    print('day id khac ${userId}');
    try {
      await ApiThanhToan.sendPaymentData(userId, amount, currency);
    } catch (error) {
      print('loi cmnr $error');
    }
  }

    
  @override
  void initState() {
    super.initState();
  
    _loadUser();

  }
  final List<PaymentItem> paymentItems = [
    PaymentItem(amount: 10.0, currency: 'USD'),
    PaymentItem(amount: 20.0, currency: 'USD'),
    PaymentItem(amount: 30.0, currency: 'USD'),
  ];

 
  @override
  Widget build(BuildContext context) {
    print('day ${currentUser?.user[0].id}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Nạp tiền'),
      ),
      body: ListView.builder(
        itemCount: paymentItems.length,
        itemBuilder: (context, index) {
          final item = paymentItems[index];
          return ListTile(
            title: Text(
              'Số tiền: ${item.amount.toStringAsFixed(2)} ${item.currency}',
              style: TextStyle(fontSize: 24),
            ),
            trailing: ElevatedButton(
              onPressed: () => _sendPaymentData(currentUser?.user[0].id ?? '' ,item.amount, item.currency),
              child: Text('Nạp tiền'),
            ),
          );
        },
      ),
    );
  }
}

class PaymentItem {
  final double amount;
  final String currency;

  PaymentItem({
    required this.amount,
    required this.currency,
  });
}