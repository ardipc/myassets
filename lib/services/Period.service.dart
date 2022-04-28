import 'package:get/get_connect.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/cache.helper.dart';

class PeriodService extends GetConnect with CacheManager {
  final box = GetStorage();

  @override
  void onInit() {
    // add your local storage here to load for every request
    var token = getToken();
    //1.base_url
    httpClient.baseUrl = box.read("apiAddress");
    //2.
    httpClient.defaultContentType = "application/json";
    httpClient.timeout = Duration(seconds: 5);
    httpClient.addResponseModifier((request, response) async {
      print(response.body);
    });
    httpClient.addRequestModifier((request) async {
      // add request here
      return request;
    });
    var headers = {'Authorization': "Bearer $token"};
    httpClient.addAuthenticator((request) async {
      request.headers.addAll(headers);
      return request;
    });
    super.onInit();
  }

  Future<Response> getNow() => get("${box.read("apiAddress")}/Api/Period");

  Future<Response> getAll() => get("${box.read("apiAddress")}/Api/Period/All");
}
