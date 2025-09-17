import 'package:zybomart/core/constants/api_endpoints.dart';
import 'package:zybomart/data/models/banner_model.dart';
import 'package:zybomart/data/providers/api_provider.dart';

class BannerRepository {
  final ApiProvider apiProvider;
  BannerRepository({required this.apiProvider});

  Future<List<BannerModel>> fetchBanners() async {
    final resp = await apiProvider.get(ApiEndpoints.banners);
    if (resp.statusCode == 200) {
      final list = resp.data is List ? resp.data as List : resp.data['results'] as List? ?? [];
      return list.map((e) => BannerModel.fromJson(e)).toList();
    }
    return [];
  }
}
