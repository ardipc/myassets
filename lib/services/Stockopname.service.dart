import 'package:get/get_connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/cache.helper.dart';

class StockopnameService extends GetConnect with CacheManager {
  final box = GetStorage();

  Future<Response> createStockopname(Map<String, dynamic> map) async {
    var token = getToken();
    return post(
      "${box.read("apiAddress")}/Api/StockOpname?stockOpnameId=${map['stockOpnameId']}&periodId=${map['periodId']}&faId=${map['faId']}&locationId=${map['locationId']}&qty=${map['qty']}&existCode=${map['existStatCode']}&tagCode=${map['tagStatCode']}&usageCode=${map['usageStatCode']}&conCode=${map['conStatCode']}&ownCode=${map['ownStatCode']}&isDeleted=false&userId=0",
      {},
      headers: {"Authorization": "Bearer $token"},
    );
  }

  Future<Response> getAllByPeriodId(var periodId) {
    var token = getToken();
    return get(
      "${box.read("apiAddress")}/Api/StockOpname/ByPageNo?periodId=$periodId&locationId=${box.read('locationId')}&pageNo=1",
      headers: {"Authorization": "Bearer $token"},
    );
  }

  Future<Response> getAll() {
    var token = getToken();
    return get(
      "${box.read("apiAddress")}/Api/StockOpname/All?locationId=${box.read('locationId')}&lastSync=1900-01-01",
      headers: {"Authorization": "Bearer $token"},
    );
  }
}
