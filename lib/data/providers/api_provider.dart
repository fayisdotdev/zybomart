import 'package:dio/dio.dart';
import 'package:zybomart/core/constants/api_endpoints.dart';
import 'package:zybomart/core/storage/token_storage.dart';


class ApiProvider {
  final Dio dio;

  ApiProvider()
      : dio = Dio(BaseOptions(
          baseUrl: ApiEndpoints.apiBase,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        )) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await TokenStorage.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (e, handler) => handler.next(e),
    ));
  }

  Future<Response> post(String path, {Map<String, dynamic>? data, Map<String, dynamic>? params}) {
    return dio.post(path, data: data, queryParameters: params);
  }

  Future<Response> get(String path, {Map<String, dynamic>? params}) {
    return dio.get(path, queryParameters: params);
  }
}
