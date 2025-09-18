import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zybomart/app.dart';
import 'package:zybomart/repositories/auth_repositories.dart';
import 'package:zybomart/repositories/wishlist_repository.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/wishlist/wishlist_bloc.dart';

void main() {
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => WishlistRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => WishlistBloc(
              wishlistRepository: context.read<WishlistRepository>(),
              storage: const FlutterSecureStorage(),
            ),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}
