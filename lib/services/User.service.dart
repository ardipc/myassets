// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserService extends GetConnect {
  final box = GetStorage();

  Future<Response> findUserByUserAndPass(String user, String password) {
    List<int> byt = utf8.encode(password);
    var encodePwd = base64.encode(byt);
    print(encodePwd);
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
}
