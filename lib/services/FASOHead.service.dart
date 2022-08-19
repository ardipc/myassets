import 'package:get/get_connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/cache.helper.dart';

class FASOHeadService extends GetConnect with CacheManager {
  final box = GetStorage();

  Future<Response> getAll() {
    // print(
    //     "${box.read("apiAddress")}/Api/FASOHead/All?locationId=${box.read('locationId')}&lastSync=1990-01-01");
    var token = getToken();
    return get(
      "${box.read("apiAddress")}/Api/FASOHead/All?locationId=${box.read('locationId')}&lastSync=1990-01-01",
      headers: {"Authorization": "Bearer $token"},
    );
  }

  Future<Response> create(Map<String, dynamic> map) {
    return post(
      "${box.read("apiAddress")}/api/FASOHead?soHeadId=${map['soHeadId']}&statusCode=${map['statusCode']}&userId=${map['userId']}",
      {},
    );
  }
}
