import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zybomart/blocs/wishlist/wishlist_state.dart';
import '../blocs/wishlist/wishlist_bloc.dart';
import '../blocs/product_bloc.dart';
import '../widgets/product_grid.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistBloc>().add(FetchWishlist());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Wishlist')),
      body: SafeArea(
        child: BlocBuilder<WishlistBloc, WishlistState>(
          builder: (context, state) {
            if (state is WishlistLoading) {
              return const _ShimmerWishlistGrid();
            } else if (state is WishlistError) {
              return Center(child: Text(state.message));
            } else if (state is WishlistLoaded) {
              final wishlistIds = state.wishlistIds;
              return BlocBuilder<ProductBloc, ProductState>(
                builder: (context, productState) {
                  if (productState is ProductLoading) {
                    return const _ShimmerWishlistGrid();
                  } else if (productState is ProductError) {
                    return Center(child: Text('Error: ${productState.message}'));
                  } else if (productState is ProductLoaded) {
                    final wishlistProducts = productState.products
                        .where((product) => wishlistIds.contains(product.id))
                        .toList();
                    if (wishlistProducts.isEmpty) {
                      return const Center(
                        child: Text(
                          'Your wishlist is empty!',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }
                    return ProductGrid(
                      products: wishlistProducts,
                      onWishlistToggle: (product) {
                        context.read<WishlistBloc>().add(
                          ToggleWishlist(product.id),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No products found'));
                  }
                },
              );
            }
            return const Center(child: Text('Loading wishlist...'));
          },
        ),
      ),
    );
  }
}

/// Shimmer placeholder grid while products are loading
class _ShimmerWishlistGrid extends StatelessWidget {
  const _ShimmerWishlistGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6, 
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(height: 14, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(height: 14, width: 40, color: Colors.white),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
