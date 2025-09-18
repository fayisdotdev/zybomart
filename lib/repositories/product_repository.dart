import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zybomart/models/product_model.dart';

Future<List<Product>> fetchProducts() async {
  final dio = Dio();

  try {
    final response = await dio.get(
      'http://skilltestflutter.zybotechlab.com/api/products/',
    );

    debugPrint('=== Response Received ===');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Response Data: ${response.data}');

    if (response.statusCode == 200) {
      final List data = response.data;
      debugPrint('Number of products fetched: ${data.length}');
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products, status: ${response.statusCode}');
    }
  } catch (e, stack) {
    debugPrint('Error fetching products: $e');
    debugPrint('Stacktrace: $stack');
    throw Exception('Error fetching products: $e');
  }
}
