import 'package:flutter/material.dart';
import 'package:loginapp/constant/asset_path_const.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/common_service.dart';
import 'package:url_launcher/url_launcher.dart';

class LienHe extends StatefulWidget {
  const LienHe({Key? key}) : super(key: key);
  static const routeName = 'lienhe';

  @override
  State<LienHe> createState() => _LienHeState();
}

class _LienHeState extends State<LienHe> {
  final Uri facebookUrl = Uri.parse("https://www.facebook.com/binhbug2501");
  final Uri emailUrl = Uri(
    scheme: 'mailto',
    path: 'totnghiepduan2023@gmail.com',
    queryParameters: {'subject': 'Đăng ký nhóm dịch'},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConst.colorPrimary50,
        centerTitle: true,
        title: const Text('Đăng ký nhóm dịch'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Text(
                'Liên hệ chúng tôi qua:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 15),
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: ColorConst.colorPrimary50),
                  padding: EdgeInsets.all(15),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Facebook',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Image.asset(
                          AssetsPathConst.ico_face,
                          height: 23,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  launchUrl(facebookUrl);
                },
              ),
              SizedBox(height: 15),
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: ColorConst.colorPrimary50),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.mail,
                          size: 23,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  launchUrl(emailUrl);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void launchUrl(Uri uri) async {
    // ignore: deprecated_member_use
    if (await canLaunch(uri.toString())) {
      // ignore: deprecated_member_use
      await launch(uri.toString());
    } else {
      CommonService.showToast(
          'Đang có lỗi từ hê thống vui lòng thử lại sau', context);
    }
  }
}
