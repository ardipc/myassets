import 'package:get/get_connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/cache.helper.dart';

class LocationService extends GetConnect with CacheManager {
  final box = GetStorage();

  Future<Response> getByCode(String code) {
    var token = getToken();
    return get(
      "${box.read("apiAddress")}/Api/Location?locationCode=$code",
      headers: {"Authorization": "Bearer $token"},
    );
  }

  Future<Response> getAll() {
    var token = getToken();
    return get(
      "${box.read("apiAddress")}/Api/Location/All?locationId=${box.read('locationId')}&lastSync=1900-01-01",
      headers: {"Authorization": "Bearer $token"},
    );
  }
}
