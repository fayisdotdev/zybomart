import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final Dio _dio = Dio();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  // Check if user exists
  Future<bool> isUserExists(String phone) async {
    try {
      debugPrint('=== Requesting /verify/ for phone: $phone ===');

      final response = await _dio.post(
        'https://skilltestflutter.zybotechlab.com/api/verify/',
        data: {'phone_number': phone},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return response.data['exists'] ?? false;
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in isUserExists: $e');
      throw Exception('Failed to verify user: $e');
    }
  }

  // Login/Register
  Future<String> loginOrRegister(String phone, {String? firstName}) async {
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
