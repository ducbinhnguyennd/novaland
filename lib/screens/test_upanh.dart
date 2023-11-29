import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/double_x.dart';
import 'package:loginapp/constant/strings_const.dart';
import 'package:loginapp/screens/hienthianh.dart';
import 'package:image/image.dart' as image_format;
import 'dart:math' as math;
import 'package:path_provider/path_provider.dart';
import '../constant/common_service.dart';
import '../model/user_model.dart';
import '../user_Service.dart';

class UploadImageScreen extends StatefulWidget {
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  XFile? _imageFile;
  final _picker = ImagePicker();
  final Dio _dio = Dio();
  Data? currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: MaterialButton(
                    onPressed: () {
                      _onImageButtonPressed(ImageSource.gallery,
                          context: context);
                    },
                    height: DoubleX.kLayoutHeightTiny_1XX,
                    color: ColorConst.colorPrimary,
                    child: const Text(
                      "Chọn ảnh...",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: ColorConst.colorPrimaryText),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: DoubleX.kPaddingSizeMedium_1XX),
              child: _imageFile != null
                  ? Center(
                      child: SizedBox(
                        width: DoubleX.kLayoutWidthHuge,
                        height: DoubleX.kLayoutHeightHuge,
                        child: Image.file(File(_imageFile!.path),
                            width: DoubleX.kSizeHuge,
                            height: DoubleX.kSizeHuge),
                      ),
                    )
                  : const Text("Bấm nút chọn ảnh ở trên để chọn ảnh!"),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () async {
                  // CommonService.appShowLoading(context, '');
                  // return;
                  if (_imageFile == null) {
                    print("Vui lòng chọn ảnh để upload");
                    // CommonService.hideLoading(context);
                    return;
                  }

                  try {
                    //decode a image avatar
                    final tempDir = await getTemporaryDirectory();
                    final path = tempDir.path;
                    int rand = math.Random().nextInt(10000);
                    if (_imageFile != null) {
                      final image = image_format.decodeImage(
                          File(_imageFile!.path).readAsBytesSync());
                      if (image != null) {
                        final thumbnail =
                            image_format.copyResize(image, width: 200);

                        File image2 = File('$path/img_$rand.jpg');

                        await image2.writeAsBytes(
                            image_format.encodeJpg(thumbnail, quality: 72));

                        uploadImageAvatar('Day la noi dung cua bai post',
                                image2.path, context)
                            .then((data) {
                          if (data != null) {
                            print("Thienlogin : uploadImageAvatar : $data");
                          } else {
                            print("Vui lòng thử lại sau");
                          }
                        });
                      }
                    }
                  } catch (e) {
                    print('lỗi gì đây $e');
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: Gradients.defaultGradientBackground),
                  child: Center(
                    child: Text(
                      'Cập nhật avatar',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onImageButtonPressed(ImageSource source, {context}) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      _imageFile = pickedFile;
    });
  }

  static Future<dynamic> uploadImageAvatar(
      String content, String path, BuildContext context) async {
    List<String> st = path.split("/");
    String filename = st[st.length - 1];
    print('Thienlogin : uploadImageAvatar : Dang upload... ');
    var body = FormData.fromMap({
      'images': await MultipartFile.fromFile(path, filename: filename),
      'content': content,
    });
    Dio dio = Dio();
    String urlTrangChu =
        'https://du-an-2023.vercel.app/postbaiviet/65646ca0d7a5053612d43992';

    Map<String, String> header = {};
    dio.options.headers = header;
    try {
      Response response = await dio.post(urlTrangChu, data: body);
      // await CommonService.hideLoading(context);
      if (kDebugMode) {
        print('thienlogin___ : response.data ${response.data}');
        print('thienlogin___ : urlTrangChu $urlTrangChu');
        print('thienlogin___ : header $header');
        print('thienlogin___ : body $body');
      }
      return response.data;
    } catch (e) {
      // await CommonService.hideLoading(context);
      DioError di = e as DioError;

      return di.message;
    } finally {
      print('Thienlogin : Upload : OKKKKKKKKKKKKK');
    }
  }
}
