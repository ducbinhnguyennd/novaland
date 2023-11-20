import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:loginapp/model/bangtin_model.dart';
import 'package:loginapp/model/category_model.dart';
import 'package:loginapp/model/detail_chapter.dart';
import 'package:loginapp/model/detailtrangchu_model.dart';
import 'package:loginapp/model/lichsuthanhtoan_model.dart';
import 'package:loginapp/model/topUser_model.dart';
import 'package:loginapp/model/trangchu_model.dart';
import 'package:loginapp/model/user_model2.dart';
import 'package:url_launcher/url_launcher.dart';

Dio dio = Dio();

class MangaService {
  static String apiUrl = "https://du-an-2023.vercel.app/mangas";

  static Future<List<Manga>> fetchMangaList() async {
    try {
      Response response = await dio.get(apiUrl);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Manga> mangas = data.map((json) => Manga.fromJson(json)).toList();
        return mangas;
      } else {
        throw Exception('Không thể lấy dữ liệu từ API');
      }
    } catch (e) {
      throw Exception('Lỗi khi kết nối đến API: $e');
    }
  }
}

class MangaDetail {
  static Future<MangaDetailModel> fetchMangaDetail(
      String mangaId, String userId) async {
    final apiUrl =
        "https://du-an-2023.vercel.app/mangachitiet/$mangaId/$userId";

    Response response = await dio.get(apiUrl);
    if (response.statusCode == 200) {
      final mangaDetail = MangaDetailModel.fromJson(response.data);
      print('binhlogin - ${mangaDetail}');
      return mangaDetail;
    } else {
      throw Exception('Không thể lấy dữ liệu từ API');
    }
  }
}

class ChapterDetail {
  static Future<ComicChapter> fetchChapterImages(
      String chapterId, String userId) async {
    final apiUrl =
        'https://du-an-2023.vercel.app/chapter/$chapterId/$userId/images';

    try {
      final response = await dio.get(apiUrl);

      if (response.statusCode == 200) {
        ComicChapter myModel = ComicChapter.fromJson(response.data);
        return myModel;
      } else {
        throw Exception('Failed to load chapter images');
      }
    } catch (e) {
      print('loi o day nay :$e');
      throw Exception('Error: $e');
    }
  }
}

class ApiListYeuThich {
  static Future<List<Manga>> fetchFavoriteManga(String userId) async {
    final response = await dio
        .get('https://du-an-2023.vercel.app/user/favoriteManga/$userId');
    if (response.statusCode == 200) {
      print(response.data);
      final List<dynamic> jsonData = response.data;
      return jsonData.map((mangaData) => Manga.fromJson(mangaData)).toList();
    } else {
      throw Exception('Failed to load favorite manga');
    }
  }
}

// cục thể loại
class CategoryService {
  final String apiUrl = 'https://du-an-2023.vercel.app/categorys';

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get(apiUrl);
      if (response.statusCode == 200) {
        List<CategoryModel> categories = (response.data as List)
            .map((categoryData) => CategoryModel.fromJson(categoryData))
            .toList();
        return categories;
      }
    } catch (e) {
      throw Exception('Failed to load categories');
    }
    return [];
  }
}

//thanh toán
class ApiThanhToan {
  static Future<void> sendPaymentData(
      String userId, double totalAmount, String currency) async {
    final url = 'https://du-an-2023.vercel.app/pay/$userId';
    try {
      final response = await dio.post(
        url,
        data: {
          'totalAmount': totalAmount.toString(),
          'currency': currency,
        },
      );

      if (response.statusCode == 200) {
        // print('binh thanh toan ${response.data}');
        final Uri paymentUri = Uri.parse(response.data);
        launchUrl(paymentUri);
      } else {
        print('loi');
      }
    } catch (error) {
      print(error);
    }
  }
}

// post comment
class CommentService {
  static Future<void> postComment(
      String userId, String mangaId, String comment) async {
    final dio = Dio();
    try {
      final response = await dio.post(
          'https://du-an-2023.vercel.app/postcomment/$userId/$mangaId',
          data: {'comment': comment});
      if (response.statusCode == 200) {
        print('binh cmt ${response.data}');
      } else {
        print('Loi cmnr');
      }
    } catch (e) {
      // Handle Dio exception
      print('Error: $e');
    }
  }
}

// xóa comment
class XoaComment {
  static Future<void> xoaComment(
      String comment, String mangaId, String userId) async {
   
    try {
      final response = await dio.post(
        'https://du-an-2023.vercel.app/deletecomment/$comment/$mangaId/$userId',
      );
      if (response.statusCode == 200) {
        print('binh xoa ${response.data}');
      } else {
        print('Loi cmnr');
      }
    } catch (e) {
      // Handle Dio exception
      print('Error: $e');
    }
  }
}

// lịch sử thanh toán
class PaymentApi {
  final String baseUrl = 'https://du-an-2023.vercel.app';

  Future<List<PaymentHistory>> getPaymentHistory(String userId) async {
    final response = await dio.get('$baseUrl/paymentdetail/$userId');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((item) => PaymentHistory.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch payment history');
    }
  }
}

// lay info user
class ApiUser {
  final String baseUrl = 'https://du-an-2023.vercel.app';

  Future<UserModel> fetchUserData(String userId) async {
    final response = await dio.get('$baseUrl/user/$userId');
    return UserModel.fromJson(response.data);
  }
}
// bxh
class ApiTopUser {
  Future<List<TopUserModel>> getUsers() async {
    try {
      Response response = await dio.get('https://du-an-2023.vercel.app/topUsers');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<TopUserModel> users =
            data.map((json) => TopUserModel.fromJson(json)).toList();
        return users;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
// trang bangtin chưa login
class ApiBangTin {
  Future<List<Bangtin>> getPosts() async {
    try {
      Response response = await dio.get("https://du-an-2023.vercel.app/getbaiviet");
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Bangtin> posts = data.map((json) => Bangtin.fromJson(json)).toList();
        return posts;
      } else {
        throw Exception("Failed to load posts");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
// đã log
class ApiBangTinDaLog {
  Future<List<Bangtin>> getPosts(String userId) async {
    try {
      Response response = await dio.get("https://du-an-2023.vercel.app/getbaiviet/$userId");
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Bangtin> posts = data.map((json) => Bangtin.fromJson(json)).toList();
        return posts;
      } else {
        throw Exception("Failed to load posts");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}

//post bài đăng
class ApiPostBaiDang {
  Future<Response> postBaiViet(String userId, String content) async {
    try {
      return await dio.post(
        'https://du-an-2023.vercel.app/postbaiviet/$userId',
        data: {'content': content},
      );
    } catch (error) {
      throw error;
    }
  }

}
// xoa bài viết 
class XoaBaiDang {
  static Future<void> xoaBaiDang(
      String baivietId, String userId) async {
   
    try {
      final response = await dio.post(
        'https://du-an-2023.vercel.app/deletebaiviet/$baivietId/$userId',
      );
      if (response.statusCode == 200) {
        print('binh xoa ${response.data}');
      } else {
        print('Loi cmnr');
      }
    } catch (e) {
      // Handle Dio exception
      print('Error: $e');
    }
  }
}
// like bài viết
class LikeApiService {
  Future<void> likeBaiViet(String userId, String baiVietId) async {
    try {
      await dio.post(
        'https://du-an-2023.vercel.app/addfavoritebaiviet/$userId/$baiVietId',
      );
    } catch (error) {
      throw error;
    }
  }
}

// post cmt bài đăng
class ApiSCommentBaiDang {
  Future<void> postComment(String baivietId, String userId, String comment) async {
    try {
      final response = await dio.post(
        'https://du-an-2023.vercel.app/postcmtbaiviet/$baivietId/$userId',
        data: {'comment': comment},
      );
      print('Response from postComment API: $response');
    } catch (error) {
      print('Error in postComment API: $error');
    }
  }
}
// xoa cmt bài viết 
class XoaCommentBaiDang {
  static Future<void> xoaComment(
      String commentId, String baivietId, String userId) async {
   
    try {
      final response = await dio.post(
        'https://du-an-2023.vercel.app/deletecmtbaiviet/$commentId/$baivietId/$userId',
      );
      if (response.statusCode == 200) {
        print('binh xoa ${response.data}');
      } else {
        print('Loi cmnr');
      }
    } catch (e) {
      // Handle Dio exception
      print('Error: $e');
    }
  }
}