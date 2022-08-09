// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/cache.helper.dart';

class UserService extends GetConnect with CacheManager {
  final box = GetStorage();

  Future<Response> findUserByUserAndPass(String user, String password) {
    List<int> byt = utf8.encode(password);
    var encodePwd = base64.encode(byt);
    return get(
        "${box.read("apiAddress")}/Api/User?usr=${user}&pwd=${encodePwd}&locationId=${box.read('locationId')}");
  }

  Future<Response> getAll() async {
    return get(
        "${box.read("apiAddress")}/Api/User/All?locationId=${box.read('locationId')}&lastSync=1900-01-01");
  }

  Future<Response> unRegister(var email, var deviceId) async {
    return post(
        "${box.read("apiAddress")}/api/Register/Unreg?email=$email&deviceId=$deviceId",
        {});
  }

  Future<Response> changePassword(Map<String, dynamic> map) {
    var token = getToken();
    return post(
      "${box.read("apiAddress")}/Api/User/ChangePwd?userId=${box.read('userId')}&oldPwd=${map['oldPwd']}&newPwd=${map['newPwd']}&confirmPwd=${map['confirmPwd']}",
      {},
      headers: {"Authorization": "Bearer $token"},
    );
  }
}
