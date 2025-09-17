import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybomart/data/providers/api_provider.dart';
import 'package:zybomart/data/repositories/banner_repository.dart';
import 'package:zybomart/data/repositories/product_repository.dart';
import 'package:zybomart/data/repositories/wishlist_repository.dart';
import 'package:zybomart/logic/banner/banner_bloc.dart';
import 'package:zybomart/logic/banner/banner_event.dart';
import 'package:zybomart/logic/product/product_bloc.dart';
import 'package:zybomart/logic/product/product_event.dart';
import 'package:zybomart/logic/wishlist/wishlist_bloc.dart';
import 'package:zybomart/logic/wishlist/wishlist_event.dart';
import 'package:zybomart/presentation/screens/product_tab.dart';
import 'package:zybomart/presentation/screens/profile_screen.dart';
import 'package:zybomart/presentation/screens/wishlist_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _idx = 0;

  @override
  Widget build(BuildContext context) {
    final api = RepositoryProvider.of<ApiProvider>(context);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => ProductRepository(apiProvider: api)),
        RepositoryProvider(create: (_) => BannerRepository(apiProvider: api)),
        RepositoryProvider(create: (_) => WishlistRepository(apiProvider: api)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (ctx) => ProductBloc(productRepository: ctx.read())..add(ProductFetchRequested())),
          BlocProvider(create: (ctx) => BannerBloc(bannerRepository: ctx.read())..add(BannerFetchRequested())),
          BlocProvider(create: (ctx) => WishlistBloc(wishlistRepository: ctx.read())..add(WishlistFetchRequested())),
        ],
        child: Scaffold(
          appBar: AppBar(title: const Text('zybomart')),
          body: IndexedStack(
            index: _idx,
            children: const [
              ProductTab(),
              WishlistScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _idx,
            onTap: (i) => setState(() => _idx = i),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Products'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
