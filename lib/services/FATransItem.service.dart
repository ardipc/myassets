import 'package:get/get_connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/cache.helper.dart';

class FATransItemService extends GetConnect with CacheManager {
  final box = GetStorage();

  Future<Response> create(Map<String, dynamic> map) {
    return post(
      "${box.read("apiAddress")}/Api/FATransItem?transItemId&transId=${map['transId']}&faId=${map['faId']}&remarks=${map['remarks']}&conStat=${map['conStat']}&oldTag=${map['oldTag']}&newTag=${map['newTag']}&userId=${map['userId']}",
      {},
    );
  }
}
