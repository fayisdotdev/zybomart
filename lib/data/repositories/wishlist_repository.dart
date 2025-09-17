

import 'package:zybomart/core/constants/api_endpoints.dart';
import 'package:zybomart/data/models/product_model.dart';
import 'package:zybomart/data/providers/api_provider.dart';

class WishlistRepository {
  final ApiProvider apiProvider;
  WishlistRepository({required this.apiProvider});

  Future<bool> addRemove(int productId) async {
    final resp = await apiProvider.post(ApiEndpoints.addRemoveWishlist, data: {'product_id': productId});
    return resp.statusCode == 200 || resp.statusCode == 201;
  }

  Future<List<ProductModel>> fetchWishlist() async {
    final resp = await apiProvider.get(ApiEndpoints.wishlist);
    if (resp.statusCode == 200) {
      final list = resp.data is List ? resp.data as List : resp.data['results'] as List? ?? [];
      return list.map((e) {
        if (e is Map && e['product'] != null) return ProductModel.fromJson(e['product']);
        return ProductModel.fromJson(e);
      }).toList();
    }
    return [];
  }
}
