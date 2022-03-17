import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:myasset/helpers/db.helper.dart';

class LoginController extends GetxController {
  DbHelper dbHelper = DbHelper();

  final username = TextEditingController();
  final password = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    username.text = "";
    password.text = "";
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    username.dispose();
    password.dispose();
    super.onClose();
  }

  void actionLogin() async {
    if (username.text == "admin" && password.text == "123") {
      Get.toNamed('/settings');
    } else {
      Get.offNamed('/home');
    }
  }
}
