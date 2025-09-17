import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybomart/logic/auth/auth_bloc.dart';
import 'package:zybomart/logic/auth/auth_event.dart';
import 'package:zybomart/logic/auth/auth_state.dart';
import 'package:zybomart/presentation/screens/home_screen.dart';


class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  bool _needName = false;
  bool _loading = false;

  // For this test, OTP is mocked — we directly call login/register with phone & optionally name
  void _verifyOtp() async {
    setState(() => _loading = true);

    final firstName = _needName ? _nameCtrl.text.trim() : null;
    // dispatch login
    context.read<AuthBloc>().add(AuthLoginRequested(phone: widget.phone, firstName: firstName));
    // wait for auth state change handled by App.root - for better UX, we can listen here or rely on global
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, dynamic>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        } else if (state is Unauthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message ?? 'Failed to login')));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Enter OTP')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('OTP sent to ${widget.phone} (mock)'),
              const SizedBox(height: 12),
              TextField(controller: _otpCtrl, decoration: const InputDecoration(labelText: 'OTP')),
              const SizedBox(height: 12),
              Row(children: [
                Checkbox(value: _needName, onChanged: (v) => setState(() => _needName = v ?? false)),
                const Text('Provide name if new user'),
              ]),
              if (_needName)
                TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'First name')),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loading ? null : _verifyOtp,
                child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Verify & Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
