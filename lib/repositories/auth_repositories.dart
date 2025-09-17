import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final storage = FlutterSecureStorage();

  Future<void> requestOtp(String phone) async {
    final response = await http.post(
      Uri.parse('http://skilltestflutter.zybotechlab.com/api/verify/'),
      body: {'phone_number': phone},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send OTP');
    }
  }

  Future<String> verifyOtp(String phone, String otp) async {
    // Mocking login/register flow
    final response = await http.post(
      Uri.parse('http://skilltestflutter.zybotechlab.com/api/login-register/'),
      body: {'phone_number': phone, 'first_name': 'DemoUser'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'] ?? "mock_jwt_token";
      await storage.write(key: 'jwt_token', value: token);
      return token;
    } else {
      throw Exception('OTP verification failed');
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
  }
}
