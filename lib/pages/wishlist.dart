import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybomart/blocs/wishlist/wishlist_state.dart';
import '../blocs/wishlist/wishlist_bloc.dart';
import '../models/product_model.dart';
import '../repositories/product_repository.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Wishlist')),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WishlistError) {
            return Center(child: Text(state.message));
          } else if (state is WishlistLoaded) {
            final wishlistIds = state.wishlistIds;

            // Fetch all products and filter only wishlist ones
            return FutureBuilder<List<Product>>(
              future: fetchProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products found'));
                }

                final wishlistProducts = snapshot.data!
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

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: wishlistProducts.length,
                  itemBuilder: (context, index) {
                    final product = wishlistProducts[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: product.images.isNotEmpty
                            ? Image.network(
                                product.images[0],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image, color: Colors.grey),
                              ),
                        title: Text(product.name),
                        subtitle: Text('\$${product.salePrice}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () {
                            context
                                .read<WishlistBloc>()
                                .add(ToggleWishlist(product.id));
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }

          return const Center(child: Text('Loading wishlist...'));
        },
      ),
    );
  }
}
