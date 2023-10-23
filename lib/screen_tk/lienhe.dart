import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LienHe extends StatefulWidget {
  const LienHe({Key? key}) : super(key: key);
  static const routeName = 'lienhe';

  @override
  State<LienHe> createState() => _LienHeState();
}

class _LienHeState extends State<LienHe> {
  final Uri url = Uri.parse("https://www.facebook.com/binhbug2501");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: const Text('Liên hệ'),
      ),
      body: Column(
        children: [
          Text(
            'Liên hệ chúng tôi qua:',
            style: TextStyle(fontSize: 18),
          ),
          InkWell(
            child: const Text(
              'Facebook',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              launchUrl(url);
            },
          ),
        ],
      ),
    );
  }
}
