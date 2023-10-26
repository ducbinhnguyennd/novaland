import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:loginapp/model/detail_chapter.dart';
import 'package:loginapp/model/detailtrangchu_model.dart';
import 'package:loginapp/model/trangchu_model.dart';

class MangaService {
  static Dio dio = Dio();
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
   static Dio dio = Dio();
  static String apiUrl = "https://du-an-2023.vercel.app/mangachitiet/";

  static Future<MangaDetailModel> fetchMangaDetail(String mangaId) async {
    Response response = await dio.get(apiUrl+mangaId);
    if (response.statusCode == 200) {
     
      final mangaDetail = MangaDetailModel.fromJson(response.data);
      return mangaDetail;
    } else {
      throw Exception('Không thể lấy dữ liệu từ API');
    }
  }

}  
class ChapterDetail{

static Future<ComicChapter> fetchChapterImages(String chapterId) async {
  final dio = Dio();
  final apiUrl = 'https://du-an-2023.vercel.app/chapter/$chapterId/images';

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
  // static Future<MangaDetail> fromJson(json) {}}