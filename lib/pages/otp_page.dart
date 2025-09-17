import 'package:flutter/material.dart';
import 'package:zybomart/blocs/auth/auth_event.dart';
import 'package:zybomart/pages/homepage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';

class OtpPage extends StatelessWidget {
  final String phone;
  final TextEditingController otpController = TextEditingController();

  OtpPage({required this.phone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter OTP', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Mock login success
                context.read<AuthBloc>().add(LoginSuccess());
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
              },
              child: Text('Verify OTP'),
            )
          ],
        ),
      ),
    );
  }
}
