class Product {
  final int id;
  final String name;
  final String description;
  final String featuredImage;
  final List<String> images;
  final num salePrice;
  final num mrp;
  bool inWishlist; // mutable to allow toggling
  final double avgRating; // for rating stars
  final String discount; // optional discount display

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.featuredImage,
    required this.images,
    required this.salePrice,
    required this.mrp,
    this.inWishlist = false,
    this.avgRating = 0.0,
    this.discount = '',
  });

  // For copying with updated values
  Product copyWith({
    int? id,
    String? name,
    String? description,
    String? featuredImage,
    List<String>? images,
    num? salePrice,
    num? mrp,
    bool? inWishlist,
    double? avgRating,
    String? discount,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      featuredImage: featuredImage ?? this.featuredImage,
      images: images ?? this.images,
      salePrice: salePrice ?? this.salePrice,
      mrp: mrp ?? this.mrp,
      inWishlist: inWishlist ?? this.inWishlist,
      avgRating: avgRating ?? this.avgRating,
      discount: discount ?? this.discount,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      featuredImage: json['featured_image'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      salePrice: (json['sale_price'] ?? 0) as num,
      mrp: (json['mrp'] ?? 0) as num,
      inWishlist: json['in_wishlist'] ?? false,
      avgRating: json['avg_rating'] != null
          ? double.tryParse(json['avg_rating'].toString()) ?? 4.0
          : 0.0,
      discount: json['discount']?.toString() ?? '',
    );
  }
}
