import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product_bloc.dart';
import '../blocs/banner_bloc.dart';
import '../blocs/wishlist/wishlist_bloc.dart';
import '../widgets/product_grid.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  // Banner auto-scroll
  final PageController _bannerController = PageController(
    viewportFraction: 0.9,
  );
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProducts());
    context.read<BannerBloc>().add(FetchBanners());
    _searchController.addListener(_onSearchChanged);

    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_bannerController.hasClients) {
        final nextPage = _bannerController.page!.toInt() + 1;
        final bannerCount = context.read<BannerBloc>().state is BannerLoaded
            ? (context.read<BannerBloc>().state as BannerLoaded).banners.length
            : 0;
        if (bannerCount > 0) {
          _bannerController.animateToPage(
            nextPage % bannerCount,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _bannerController.dispose();
    _bannerTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        context.read<ProductBloc>().add(SearchProducts(query));
      } else {
        context.read<ProductBloc>().add(FetchProducts());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main scrollable content
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 100,
              ), 
              child: Column(
                children: [
                  const SizedBox(height: 20), // gap between search and banners
                  // Banners Carousel
                  BlocBuilder<BannerBloc, BannerState>(
                    builder: (context, state) {
                      if (state is BannerLoading) {
                        return SizedBox(
                          height: 180,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (context, index) => Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else if (state is BannerError) {
                        return SizedBox(
                          height: 180,
                          child: Center(child: Text('Error loading banners')),
                        );
                      } else if (state is BannerLoaded &&
                          state.banners.isNotEmpty) {
                        final banners = state.banners;
                        return SizedBox(
                          height: 180,
                          child: PageView.builder(
                            controller: _bannerController,
                            itemCount: banners.length,
                            itemBuilder: (context, index) {
                              final banner = banners[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    banner.image,
                                    fit: BoxFit.fill,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: Colors.grey[300],
                                              child: const Center(
                                                child: Icon(
                                                  Icons.image,
                                                  size: 40,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const SizedBox(
                          height: 180,
                          child: Center(child: Text('No banners')),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  // Products Grid
                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.65,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state is ProductError) {
                        return SizedBox(
                          height: 300,
                          child: Center(child: Text('Error: ${state.message}')),
                        );
                      } else if (state is ProductLoaded &&
                          state.products.isNotEmpty) {
                        return ProductGrid(
                          products: state.products,
                          onWishlistToggle: (product) {
                            context.read<WishlistBloc>().add(
                              ToggleWishlist(product.id),
                            );
                          },
                        );
                      } else {
                        return const SizedBox(
                          height: 300,
                          child: Center(child: Text('No products found')),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Floating Search Bar
            Positioned(
              top: 10,
              left: 16,
              right: 16,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
