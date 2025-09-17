

import 'package:zybomart/core/constants/api_endpoints.dart';
import 'package:zybomart/data/models/product_model.dart';
import 'package:zybomart/data/providers/api_provider.dart';

class ProductRepository {
  final ApiProvider apiProvider;
  ProductRepository({required this.apiProvider});

  Future<List<ProductModel>> fetchProducts() async {
    final resp = await apiProvider.get(ApiEndpoints.products);
    if (resp.statusCode == 200) {
      final list = resp.data is List ? resp.data as List : resp.data['results'] as List? ?? [];
      return list.map((e) => ProductModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<ProductModel>> search(String query) async {
    final resp = await apiProvider.post(ApiEndpoints.search, params: {'query': query});
    if (resp.statusCode == 200) {
      final list = resp.data is List ? resp.data as List : resp.data['results'] as List? ?? [];
      return list.map((e) => ProductModel.fromJson(e)).toList();
    }
    return [];
  }
}
