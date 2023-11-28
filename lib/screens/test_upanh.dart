import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginapp/screens/hienthianh.dart';
import 'package:image/image.dart' as img;

class UploadImageScreen extends StatefulWidget {
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _imageFile;
  final picker = ImagePicker();
  final Dio _dio = Dio();

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      return;
    }

    // Giảm kích thước của ảnh trước khi chuyển đổi thành base64
    Uint8List imageBytes = await _imageFile!.readAsBytes();
    int quality = 1; // Điều chỉnh chất lượng ảnh theo ý muốn

    // Sử dụng thư viện image để giảm kích thước ảnh
    img.Image image = img.decodeImage(imageBytes)!;
    List<int> compressedBytes = img.encodeJpg(image, quality: quality * 100);

    Uint8List uint8List = Uint8List.fromList(compressedBytes);

    // Sử dụng Uint8List trực tiếp
    String base64Image = base64Encode(uint8List);

    String uploadUrl =
        'https://du-an-2023.vercel.app/postbaiviet/65646ca0d7a5053612d43992';

    try {
      var response = await _dio.post(
        uploadUrl,
        data: {'content': 'alo', 'image': base64Image},
      );

      if (response.statusCode == 200) {
        // Handle the success case
        print('Image uploaded successfully!');

        // Hiển thị SnackBar sau khi upload thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image uploaded successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // Handle the failure case
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle the exception
      print('Error uploading image: $e');
    }
  }

  Future<void> _viewInfo() async {
    if (_imageFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayInfoScreen(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('No Image Selected'),
            content: Text('Please choose an image before viewing info.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

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
            _imageFile == null
                ? Text('No image selected.')
                : Image.file(_imageFile!),
            ElevatedButton(
              onPressed: _getImage,
              child: Text('Choose Image'),
            ),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
            ),
            ElevatedButton(
              onPressed: _viewInfo,
              child: Text('View Info'),
            ),
          ],
        ),
      ),
    );
  }
}
