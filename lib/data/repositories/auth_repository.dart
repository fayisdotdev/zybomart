import 'package:zybomart/core/constants/api_endpoints.dart';
import 'package:zybomart/core/storage/token_storage.dart';
import 'package:zybomart/data/providers/api_provider.dart';


class AuthRepository {
  final ApiProvider apiProvider;

  AuthRepository({required this.apiProvider});

  Future<bool> verifyUser(String phone) async {
    final resp = await apiProvider.post(ApiEndpoints.verifyUser, data: {'phone_number': phone});
    return resp.statusCode == 200;
  }

  Future<String?> loginRegister(String phone, {String? firstName}) async {
    final body = {'phone_number': phone};
    if (firstName != null) body['first_name'] = firstName;
    final resp = await apiProvider.post(ApiEndpoints.loginRegister, data: body);
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      final token = resp.data['token'] ?? resp.data['access'] ?? resp.data['jwt_token'];
      if (token != null) {
        await TokenStorage.saveToken(token.toString());
        return token.toString();
      }
    }
    return null;
  }

  Future<void> logout() async {
    await TokenStorage.deleteToken();
  }
}
