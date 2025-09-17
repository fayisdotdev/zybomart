import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybomart/pages/homepage.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';

class OtpPage extends StatelessWidget {
  final String phone;
  final bool userExists;
  final String otp; // ✅ add this

  final TextEditingController otpController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  OtpPage({required this.phone, required this.userExists, required this.otp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter OTP',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text("👉 Your OTP is: $otp"), // for skill test
            SizedBox(height: 20),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
            ),
            if (!userExists) ...[
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            SizedBox(height: 20),
            // OtpPage snippet
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Authenticated) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomePage(
                        phone: phone,
                        name: userExists
                            ? 'Existing User' // or fetch real name if API returns
                            : nameController.text.trim(),
                      ),
                    ),
                    (route) => false,
                  );
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) return CircularProgressIndicator();
                return ElevatedButton(
                  onPressed: () {
                    if (otpController.text.trim() != otp) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Invalid OTP. Please enter $otp"),
                        ),
                      );
                      return;
                    }

                    context.read<AuthBloc>().add(
                      VerifyOtp(
                        phone: phone,
                        otp: otpController.text.trim(),
                        firstName: nameController.text.isNotEmpty
                            ? nameController.text
                            : null,
                      ),
                    );
                  },
                  child: Text('Verify OTP'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
