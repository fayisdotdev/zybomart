class Product {
  final int id;
  final String name;
  final String description;
  final String featuredImage;
  final List<String> images;
  final num salePrice;
  final num mrp;
  final bool inWishlist;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.featuredImage,
    required this.images,
    required this.salePrice,
    required this.mrp,
    required this.inWishlist,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      featuredImage: json['featured_image'] ?? '',
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : [],
      salePrice: (json['sale_price'] ?? 0) as num,
      mrp: (json['mrp'] ?? 0) as num,
      inWishlist: json['in_wishlist'] ?? false,
    );
  }
}
