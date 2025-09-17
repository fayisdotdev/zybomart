import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybomart/core/constants/api_endpoints.dart';
import 'package:zybomart/core/storage/token_storage.dart';
import 'package:zybomart/data/providers/api_provider.dart';
import 'package:zybomart/logic/auth/auth_bloc.dart';
import 'package:zybomart/logic/auth/auth_event.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() => _loading = true);
    try {
      final token = await TokenStorage.getToken();
      final api = ApiProvider();
      final resp = await api.get(ApiEndpoints.userData, params: {});
      if (resp.statusCode == 200) {
        setState(() => _profile = Map<String, dynamic>.from(resp.data));
      }
    } catch (e) {
      // ignore
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(radius: 36, child: Text(_profile?['first_name']?.substring(0, 1) ?? 'U')),
                const SizedBox(height: 12),
                Text(_profile?['first_name'] ?? 'Unknown', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(_profile?['phone_number'] ?? ''),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLoggedOut());
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
  }
}
