import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:zybomart/data/models/banner_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BannerSlider extends StatelessWidget {
  final List<BannerModel> banners;
  const BannerSlider({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) return const SizedBox.shrink();
    return CarouselSlider(
      options: CarouselOptions(
        height: 150.0,
        viewportFraction: 0.9,
        enableInfiniteScroll: true,
        autoPlay: true,
      ),
      items: banners.map((b) {
        return Builder(
          builder: (BuildContext context) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: CachedNetworkImage(
                imageUrl: b.image,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (c, s) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (c, s, e) =>
                    const Center(child: Icon(Icons.broken_image)),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
