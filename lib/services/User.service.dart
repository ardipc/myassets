// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserService extends GetConnect {
  final box = GetStorage();

  Future<Response> findUserByUserAndPass(String user, String password) {
    List<int> byt = utf8.encode(password);
    var encodePwd = base64.encode(byt);
    print(user);
    print(password);
    print(encodePwd);
    print("${box.read("apiAddress")}/Api/User?usr=${user}&pwd=${encodePwd}");
    return get(
        "${box.read("apiAddress")}/Api/User?usr=${user}&pwd=${encodePwd}");
  }
}
