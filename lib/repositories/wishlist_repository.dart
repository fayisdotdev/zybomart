import 'package:dio/dio.dart';

class WishlistRepository {
  final Dio _dio = Dio();

  Future<void> toggleWishlist({
    required int productId,
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        'https://skilltestflutter.zybotechlab.com/api/add-remove-wishlist/',
        data: {"product_id": productId},
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Wishlist updated for product $productId");
      } else {
        print("⚠️ Failed: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error updating wishlist: $e");
      rethrow;
    }
  }

  Future<List<int>> fetchWishlist({required String token}) async {
    try {
      final response = await _dio.get(
        'https://skilltestflutter.zybotechlab.com/api/wishlist/',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
      if (response.statusCode == 200 && response.data is List) {
        final List data = response.data;
        // Assuming API returns a list of products, each with an 'id' field
        return data.map<int>((item) => item['id'] as int).toList();
      } else {
        throw Exception('Failed to fetch wishlist: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Error fetching wishlist: $e");
      rethrow;
    }
  }
}
