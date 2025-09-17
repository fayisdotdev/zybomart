import 'package:flutter/material.dart';
import 'package:zybomart/core/utils/validators.dart';
import 'package:zybomart/presentation/screens/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  void _continue() async {
    if (!_formKey.currentState!.validate()) return;
    final phone = _phoneCtrl.text.trim();

    // call verify endpoint quickly: since verify might return 200 or 404 - we proceed to OTP screen regardless
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => OtpScreen(phone: phone)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('zybomart - Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone number', prefix: Text('+91 ')),
                validator: Validators.validatePhone,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _continue,
              child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
