import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybomart/logic/wishlist/wishlist_bloc.dart';
import 'package:zybomart/logic/wishlist/wishlist_event.dart';
import 'package:zybomart/logic/wishlist/wishlist_state.dart';
import 'package:zybomart/presentation/widgets/product_grid.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistBloc, WishlistState>(
      builder: (context, state) {
        if (state is WishlistLoading)
          return const Center(child: CircularProgressIndicator());
        if (state is WishlistLoaded) {
          return ProductGrid(
            products: state.items,
            wishlistIds: state.items.map((e) => e.id).toSet(),
            onToggleWishlist: (pid) =>
                context.read<WishlistBloc>().add(WishlistToggleRequested(pid)),
          );
        }
        if (state is WishlistError)
          return Center(child: Text('Error: ${state.message}'));
        return const Center(child: Text('No items in wishlist'));
      },
    );
  }
}
