import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybomart/logic/banner/banner_bloc.dart';
import 'package:zybomart/logic/banner/banner_state.dart';
import 'package:zybomart/presentation/widgets/banner_slider.dart';
import 'package:zybomart/logic/product/product_bloc.dart';
import 'package:zybomart/logic/product/product_state.dart';
import 'package:zybomart/presentation/widgets/product_grid.dart';
import 'package:zybomart/logic/product/product_event.dart';
import 'package:zybomart/logic/wishlist/wishlist_bloc.dart';
import 'package:zybomart/logic/wishlist/wishlist_event.dart';
import 'package:zybomart/logic/wishlist/wishlist_state.dart';

class ProductTab extends StatefulWidget {
  const ProductTab({super.key});

  @override
  State<ProductTab> createState() => _ProductTabState();
}

class _ProductTabState extends State<ProductTab> {
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search products',
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  final q = _searchCtrl.text.trim();
                  context.read<ProductBloc>().add(ProductSearchRequested(q));
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
        // Banner
        BlocBuilder<BannerBloc, BannerState>(
          builder: (context, state) {
            if (state is BannerLoading)
              return const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              );
            if (state is BannerLoaded)
              return BannerSlider(banners: state.banners);
            return const SizedBox.shrink();
          },
        ),
        // Product grid
        Expanded(
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading)
                return const Center(child: CircularProgressIndicator());
              if (state is ProductLoaded) {
                return BlocBuilder<WishlistBloc, WishlistState>(
                  builder: (context, wstate) {
                    final wishIds = <int>{};
                    if (wstate is WishlistLoaded)
                      wishIds.addAll(wstate.items.map((e) => e.id));
                    return ProductGrid(
                      products: state.products,
                      wishlistIds: wishIds,
                      onToggleWishlist: (pid) => context
                          .read<WishlistBloc>()
                          .add(WishlistToggleRequested(pid)),
                    );
                  },
                );
              }
              if (state is ProductError)
                return Center(child: Text('Error: ${state.message}'));
              return const Center(child: Text('No products'));
            },
          ),
        ),
      ],
    );
  }
}
