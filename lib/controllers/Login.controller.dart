import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/models/preferences.model.dart';
import 'package:myasset/models/user.model.dart';
import 'package:sqflite/sqlite_api.dart';

class LoginController extends GetxController {
  DbHelper dbHelper = DbHelper();

  final username = TextEditingController();
  final password = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    print("init login");
    username.clear();
    password.clear();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    print("close");
    username.text = "";
    password.text = "";
    super.onClose();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("dispose");
    username.dispose();
    password.dispose();
    super.dispose();
  }

  void actionLogin() async {
    final box = GetStorage();
    Database db = await dbHelper.initDb();
    if (username.text == "admin" && password.text == "123") {
      Get.offNamed('/settings');
    } else {
      List<User> users =
          await dbHelper.selectUserToLogin(username.text, password.text);
      if (users.isEmpty) {
        Get.snackbar("Message", "Username and password not found!");
      } else {
        box.write('userId', users[0].userId);
        box.write('username', username.text);
        box.write('roleId', users[0].roleId);
        box.write('roleName', users[0].roleName);
        box.write('realName', users[0].realName);
        Get.offNamed('/home');
      }
    }
  }

  void actionLogout() async {
    final box = GetStorage();
    box.remove('userId');
    box.remove('username');
    box.remove('roleId');
    box.remove('roleName');
    box.remove('realName');
    Get.offAllNamed('/login');
  }
}
