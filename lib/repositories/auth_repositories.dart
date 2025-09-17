import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final Dio _dio = Dio();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  // Check if user exists and get OTP
  Future<Map<String, dynamic>> isUserExists(String phone) async {
    try {
      final response = await _dio.post(
        'https://skilltestflutter.zybotechlab.com/api/verify/',
        data: {'phone_number': phone},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return {
          'userExists': response.data['user'] ?? false,
          'otp': response.data['otp']?.toString() ?? '',
        };
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to verify user: $e');
    }
  }

  // Login/Register
  Future<Map<String, dynamic>> loginOrRegister(
    String phone, {
    String? firstName,
  }) async {
    try {
      debugPrint('=== Login/Register request body ===');
      debugPrint('Phone: $phone, First Name: ${firstName ?? ''}');

      final response = await _dio.post(
        'https://skilltestflutter.zybotechlab.com/api/login-register/',
        data: {'phone_number': phone, 'first_name': firstName ?? ''},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200 && response.data['token'] != null) {
        final token = response.data['token']['access'] ?? '';
        final name = response.data['name'] ?? firstName ?? '';
        await storage.write(key: 'jwt_token', value: token);
        await storage.write(key: 'user_phone', value: phone);
        await storage.write(key: 'user_name', value: name);
        return {'token': token, 'phone': phone, 'name': name};
      } else {
        throw Exception('No token received from API');
      }
    } catch (e) {
      debugPrint('Error in loginOrRegister: $e');
      throw Exception('Login/Register failed: $e');
    }
  }

  // Fetch user profile
  // Fetch user profile
  Future<Map<String, dynamic>> fetchUserProfile(String token) async {
    try {
      debugPrint(
        'Fetching user profile with token: $token',
      ); // <-- Debug line added
      final response = await _dio.get(
        'https://skilltestflutter.zybotechlab.com/user-data/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint(
        'Profile response status: ${response.statusCode}',
      ); // <-- Debug line added
      debugPrint(
        'Profile response data: ${response.data}',
      ); // <-- Debug line added

      if (response.statusCode == 200) {
        return {
          'name': response.data['first_name'] ?? '',
          'phone': response.data['phone_number'] ?? '',
        };
      } else {
        throw Exception('Failed to fetch profile: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e'); // <-- Debug line added
      debugPrint(
        'Requesting user profile at: https://skilltestflutter.zybotechlab.com/user-data/',
      );
      debugPrint('Authorization header: Bearer $token');
      throw Exception('Error fetching profile: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
    debugPrint('User logged out, token cleared');
  }

  // Get stored token
  Future<String?> getToken() async {
    final token = await storage.read(key: 'jwt_token');
    debugPrint('Retrieved token: $token');
    return token;
  }
}
