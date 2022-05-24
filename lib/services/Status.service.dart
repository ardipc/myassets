import 'package:get/get_connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/cache.helper.dart';

class StatusService extends GetConnect with CacheManager {
  final box = GetStorage();

  Future<Response> getAll() {
    var token = getToken();
    return get(
      "${box.read("apiAddress")}/Api/Status/All?lastSync=1900-01-01",
      headers: {"Authorization": "Bearer $token"},
    );
  }
}
