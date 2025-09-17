import 'product_model.dart';

class WishlistModel {
  final int id;
  final ProductModel product;

  WishlistModel({required this.id, required this.product});

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['id'] ?? 0,
      product: ProductModel.fromJson(json['product'] ?? json),
    );
  }
}
