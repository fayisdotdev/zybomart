class BannerModel {
  final int id;
  final String name;
  final String image;

  BannerModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
