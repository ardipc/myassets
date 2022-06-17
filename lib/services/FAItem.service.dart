import 'package:get/get_connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/cache.helper.dart';

class FAItemService extends GetConnect with CacheManager {
  final box = GetStorage();

  Future<Response> getAll() {
    var token = getToken();
    return get(
      "${box.read("apiAddress")}/Api/FAItem/all?locationId=${box.read('locationId')}&lastSync=1900-01-01",
      // "${box.read("apiAddress")}/Api/FAItem/all?locationId=192&lastxSync=1900-01-01",
      headers: {"Authorization": "Bearer $token"},
    );
  }
}
