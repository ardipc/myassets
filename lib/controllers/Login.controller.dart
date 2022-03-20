import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/models/user.model.dart';

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
      Get.offNamed('/settings');
    } else {
      List<User> users =
          await dbHelper.selectUserToLogin(username.text, password.text);
      if (users.isEmpty) {
        Get.snackbar("Message", "Username and password not found!");
      } else {
        Get.offNamed('/home');
      }
    }
  }
}
