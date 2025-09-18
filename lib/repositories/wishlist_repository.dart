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
}
