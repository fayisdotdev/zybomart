import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybomart/pages/homepage.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';

class OtpPage extends StatelessWidget {
  final String phone;
  final bool userExists;
  final String otp; // <-- Add this line
  final TextEditingController otpController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  OtpPage({
    required this.phone,
    required this.userExists,
    required this.otp,
  }); // <-- Update constructor

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
            SizedBox(height: 10),
            Text(
              'For testing, enter this OTP: $otp', // <-- Show OTP
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
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
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            SizedBox(height: 20),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Authenticated) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => HomePage()),
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
                    final firstName = userExists
                        ? null
                        : nameController.text.trim();
                    debugPrint('Verify OTP pressed');
                    debugPrint('Phone: $phone, First Name: $firstName');

                    context.read<AuthBloc>().add(
                      VerifyOtp(phone: phone, firstName: firstName),
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
