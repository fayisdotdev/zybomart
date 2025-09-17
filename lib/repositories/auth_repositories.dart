import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final Dio _dio = Dio();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  // Check if user exists
  Future<Map<String, dynamic>> isUserExists(String phone) async {
    try {
      final response = await _dio.post(
        'https://skilltestflutter.zybotechlab.com/api/verify/',
        data: {'phone_number': phone},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return {
          'exists': response.data['user'] ?? true, // fallback true
          'otp': response.data['otp'] ?? '1234', // fallback mock
        };
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to verify user: $e');
    }
  }

  // Login/Register
  Future<String> loginOrRegister(String phone, {String? firstName}) async {
    try {
      debugPrint('=== Login/Register request body ===');
      debugPrint('Phone: $phone, First Name: ${firstName ?? 'N/A'}');

      // Build request body
      final data = {'phone_number': phone};
      if (firstName != null && firstName.isNotEmpty) {
        data['first_name'] = firstName;
      }

      // API call
      final response = await _dio.post(
        'https://skilltestflutter.zybotechlab.com/api/login-register/',
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200 && response.data['token'] != null) {
        final tokenMap = response.data['token'];
        final token = tokenMap['access'] ?? '';
        await storage.write(key: 'jwt_token', value: token);
        debugPrint('Token saved successfully: $token');
        return token;
      } else {
        throw Exception('No token received from API');
      }
    } catch (e) {
      debugPrint('Error in loginOrRegister: $e');
      throw Exception('Login/Register failed: $e');
    }
  }

  //profile
  // Fetch profile using saved token
  Future<Map<String, dynamic>> fetchProfile(String token) async {
    try {
      final response = await _dio.get(
        'https://skilltestflutter.zybotechlab.com/user-data/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Profile response status: ${response.statusCode}');
      debugPrint('Profile response data: ${response.data}');

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Failed to fetch profile: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in fetchProfile: $e');
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
