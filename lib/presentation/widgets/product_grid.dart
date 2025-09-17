import 'package:flutter/material.dart';
import 'package:zybomart/data/models/product_model.dart';
import 'wishlist_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductModel> products;
  final void Function(int productId) onToggleWishlist;
  final Set<int> wishlistIds;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onToggleWishlist,
    required this.wishlistIds,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text('No products found'));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.66,
      ),
      itemBuilder: (ctx, i) {
        final p = products[i];
        final isWish = wishlistIds.contains(p.id);
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: p.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (c, s) => const SizedBox(
                    height: 60,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (c, s, e) => const Icon(Icons.broken_image),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  p.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text(
                      '₹${p.price}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    WishlistIcon(
                      isWish: isWish,
                      onTap: () => onToggleWishlist(p.id),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
