import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/features/sites/data/models/create_site_model.dart';
import 'package:frontend/features/sites/data/models/site_detail_model.dart';
import 'package:frontend/features/sites/data/models/site_model.dart';

class SiteService {
  final ApiClient _apiClient = ApiClient();

  Future<List<SiteModel>> getSites() async {
    final json = await _apiClient.get('sites');

    List<SiteModel> sites= [];
    for(final site in json['data']) {
      sites.add(SiteModel.fromJson(site));
    }
    return sites;
  }

  Future<SiteDetailModel> getSiteDetail(String siteId) async {
    final json = await _apiClient.get('sites/$siteId');
    return SiteDetailModel.fromJson(json['data']);
  }

  Future<bool> createSite(CreateSiteModel site) async {
    final json = await _apiClient.post('sites', site.toJson());
    return json['success'];
  }
}