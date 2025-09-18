import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/banner_model.dart';

Future<List<BannerModel>> fetchBanners() async {
  final dio = Dio();

  try {
    final response = await dio.get('http://skilltestflutter.zybotechlab.com/api/banners/');
    debugPrint('=== Banners Response ===');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Data: ${response.data}');

    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => BannerModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load banners, status: ${response.statusCode}');
    }
  } catch (e, stack) {
    debugPrint('Error fetching banners: $e');
    debugPrint('Stacktrace: $stack');
    throw Exception('Error fetching banners: $e');
  }
}
