
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';

class PostBaiVietScreen extends StatefulWidget {
  final String userId;

  const PostBaiVietScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _PostBaiVietScreenState createState() => _PostBaiVietScreenState();
}

class _PostBaiVietScreenState extends State<PostBaiVietScreen> {
  TextEditingController contentController = TextEditingController();
  ApiPostBaiDang apiService = ApiPostBaiDang();

  void _sendPost() async {
    String content = contentController.text;

    if (content.isNotEmpty) {
      try {
        await apiService.postBaiViet(widget.userId, content);
        Fluttertoast.showToast(
        msg: 'Đăng bài viết thành công',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );

        Navigator.pop(context,true);
      } catch (error) {
       Fluttertoast.showToast(
        msg: '${error}',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text('Viết bài mới'),
        backgroundColor: ColorConst.colorPrimary50,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Nhập nội dung bài đăng...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            InkWell(
          
              onTap: (() {
                _sendPost();
              }),
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: ColorConst.colorPrimary50),child: Center(child: Text('Đăng bài',style: TextStyle(fontSize: 20,color: Colors.white),)),),
            )
          ],
        ),
      ),
    );
  }
}
// class InventoryData {
//   final bool dataToPass;
//   final bool boolValue;

//   InventoryData(this.dataToPass, this.boolValue);
// }
