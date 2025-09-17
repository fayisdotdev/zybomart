class BannerModel {
  final int id;
  final String image;
  final String link;

  BannerModel({required this.id, required this.image, this.link = ''});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      link: json['link'] ?? '',
    );
  }
}
