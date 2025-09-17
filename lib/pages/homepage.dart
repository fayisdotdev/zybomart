import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../repositories/auth_repositories.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? name;
  String? phone;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final state = context.read<AuthBloc>().state;
    if (state is Authenticated) {
      try {
        final repo = RepositoryProvider.of<AuthRepository>(context);
        final profile = await repo.fetchUserProfile(state.token);
        setState(() {
          name = profile['name'];
          phone = profile['phone'];
          loading = false;
        });
      } catch (e) {
        setState(() {
          error = e.toString();
          loading = false;
        });
      }
    } else {
      setState(() {
        error = 'User not authenticated';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: Text('Zybomart Home')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Zybomart Home')),
        body: Center(child: Text(error!)),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text('Zybomart Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, $name!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Phone: $phone', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}