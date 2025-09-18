import 'package:dio/dio.dart';

class ProfileRepository {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> fetchProfile({required String token}) async {
    const url = 'https://skilltestflutter.zybotechlab.com/api/user-data/';
    try {
      print('ProfileRepository: Using token: $token');
      print('ProfileRepository: Requesting URL: $url');

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('ProfileRepository: Response status: ${response.statusCode}');
      print('ProfileRepository: Response data: ${response.data}');

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch profile: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Error fetching profile: $e");
      rethrow;
    }
  }
}
