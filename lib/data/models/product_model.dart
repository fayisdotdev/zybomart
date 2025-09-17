class ProductModel {
  final int id;
  final String name;
  final String image;
  final String price;

  ProductModel({required this.id, required this.name, required this.image, required this.price});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      name: json['name'] ?? json['product_name'] ?? '',
      image: json['image'] ?? json['thumbnail'] ?? '',
      price: json['price']?.toString() ?? '',
    );
  }
}
