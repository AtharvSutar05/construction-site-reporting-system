import 'package:frontend/features/sites/data/models/create_site_model.dart';
import 'package:frontend/features/sites/data/models/site_detail_model.dart';
import 'package:frontend/features/sites/data/models/site_model.dart';
import 'package:frontend/features/sites/data/services/site_service.dart';

class SiteRepository {
  final SiteService _siteService = SiteService();

  Future<List<SiteModel>> getSites() async {
    return await _siteService.getSites();
  }

  Future<SiteDetailModel> getSiteDetail(String siteId) async {
    return await _siteService.getSiteDetail(siteId);
  }

  Future<bool> createSite(CreateSiteModel site) async {
    return await _siteService.createSite(site);
  }
}
