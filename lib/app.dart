import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybomart/logic/auth/auth_event.dart';
import 'package:zybomart/logic/auth/auth_state.dart';
// import 'core/storage/token_storage.dart';
import 'logic/auth/auth_bloc.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'data/providers/api_provider.dart';
import 'data/repositories/auth_repository.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final apiProvider = ApiProvider();
    final authRepo = AuthRepository(apiProvider: apiProvider);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: apiProvider),
        RepositoryProvider.value(value: authRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(authRepository: authRepo)..add(AuthCheckRequested()),
          ),
        ],
        child: MaterialApp(
          title: 'zybomart',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.red),
          home: const RootDecider(),
        ),
      ),
    );
  }
}

class RootDecider extends StatelessWidget {
  const RootDecider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const HomeScreen();
        } else if (state is Unauthenticated || state is AuthInitial) {
          return const LoginScreen();
        } else if (state is AuthLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
