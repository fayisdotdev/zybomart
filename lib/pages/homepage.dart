import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybomart/blocs/wishlist/wishlist_bloc.dart';
import 'package:zybomart/blocs/wishlist/wishlist_state.dart';
import '../repositories/product_repository.dart';
import '../repositories/banner_repository.dart';
import '../models/product_model.dart';
import '../models/banner_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _productsFuture;
  late Future<List<BannerModel>> _bannersFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
    _bannersFuture = fetchBanners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zybomart')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banners Carousel
            FutureBuilder<List<BannerModel>>(
              future: _bannersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 150,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return SizedBox(
                    height: 150,
                    child: Center(child: Text('Error loading banners')),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SizedBox(
                    height: 150,
                    child: Center(child: Text('No banners')),
                  );
                }

                final banners = snapshot.data!;
                return SizedBox(
                  height: 150,
                  child: PageView.builder(
                    itemCount: banners.length,
                    controller: PageController(viewportFraction: 0.9),
                    itemBuilder: (context, index) {
                      final banner = banners[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            banner.image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.image, size: 40, color: Colors.grey),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 8),

            // Products Grid
            FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return SizedBox(
                    height: 300,
                    child: Center(child: Text('Error: ${snapshot.error}')),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SizedBox(
                    height: 300,
                    child: Center(child: Text('No products found')),
                  );
                }

                final products = snapshot.data!;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                // Product Image
                                Positioned.fill(
                                  child: product.images.isNotEmpty
                                      ? Image.network(
                                          product.images[0],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[300],
                                              child: const Center(
                                                child: Icon(Icons.image, size: 40, color: Colors.grey),
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: Icon(Icons.image, size: 40, color: Colors.grey),
                                          ),
                                        ),
                                ),

                                // Wishlist Icon Button
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: BlocBuilder<WishlistBloc, WishlistState>(
                                    builder: (context, state) {
                                      bool isInWishlist = product.inWishlist;

                                      if (state is WishlistLoaded) {
                                        isInWishlist = state.wishlistIds.contains(product.id);
                                      }

                                      return IconButton(
                                        icon: Icon(
                                          isInWishlist ? Icons.favorite : Icons.favorite_border,
                                          color: isInWishlist ? Colors.red : Colors.grey,
                                        ),
                                        onPressed: () {
                                          context.read<WishlistBloc>().add(
                                                ToggleWishlist(product.id),
                                              );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '\$${product.salePrice}',
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
