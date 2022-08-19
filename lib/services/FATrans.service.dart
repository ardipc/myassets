import 'package:get/get_connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/cache.helper.dart';

class FATransService extends GetConnect with CacheManager {
  final box = GetStorage();

  Future<Response> create(Map<String, dynamic> map) {
    return post(
      "${box.read("apiAddress")}/Api/FATrans?transId=${map['transId']}&plantId=${map['plantId']}&transDate=${map['transDate']}&manualRef=${map['manualRef']}&otherRef=${map['otherRef']}&transferType=${map['transferType']}&oldLocId=${map['oldLocId']}&newLocId=${map['newLocId']}&isApproved=${map['isApproved']}&isVoid=${map['isVoid']}&userId=${map['userId']}",
      {},
    );
  }

  Future<Response> getAll() {
    var token = getToken();
    return get(
      "${box.read("apiAddress")}/Api/FATrans/All?locationId=${box.read('locationId')}&lastSync=1976-06-13T20:04:59.924Z",
      headers: {"Authorization": "Bearer $token"},
    );
  }
}
