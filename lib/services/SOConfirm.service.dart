import 'package:get/get_connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/cache.helper.dart';

class SOConfirmService extends GetConnect with CacheManager {
  final box = GetStorage();

  Future<Response> getNow() {
    var token = getToken();
    return get(
      "${box.read("apiAddress")}/Api/Period",
      headers: {"Authorization": "Bearer $token"},
    );
  }

  Future<Response> getAll() {
    var token = getToken();
    return get(
      "${box.read("apiAddress")}/Api/Period/All?lastSync=1900-01-01",
      headers: {"Authorization": "Bearer $token"},
    );
  }
}
