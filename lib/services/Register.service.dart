import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/cache.helper.dart';

class RegisterService extends GetConnect with CacheManager {
  final box = GetStorage();

  Future<Response> register(String email, String deviceId) async {
    final token = getToken();
    String url =
        "${box.read('apiAddress')}/api/Register?email=$email&deviceId=$deviceId";
    Map body = {};
    return post(
      url,
      body,
      headers: {"Authorization": "Bearer $token"},
    );
  }

  Future<Response> checkOtp(String email, String locationId, String otp) async {
    final token = getToken();
    String url =
        "${box.read('apiAddress')}/api/Register/CheckOTP?email=$email&locationId=$locationId&otp=$otp";
    Map body = {};
    return post(url, body, headers: {"Authorization": "Bearer $token"});
  }

  Future<Response> resendOtp(String email, String deviceId) async {
    final token = getToken();
    String url =
        "${box.read('apiAddress')}/api/Register/ResendOTP?email=$email&deviceId=$deviceId";
    Map body = {};
    return post(
      url,
      body,
      headers: {"Authorization": "Bearer $token"},
    );
  }
}
