import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
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
    Database db = await dbHelper.initDb();
    if (username.text == "admin" && password.text == "123") {
      // Preferences obj = Preferences(
      // 1, "true", "-", "-", "-", "-", 0, "-", "-", 0, "-", 0, 0, "-", 0, 0);

      // print(obj.toMap());

      // int count = await db
      // .update("preferences", obj.toMap(), where: "id = ?", whereArgs: [1]);

      // int count = await db.insert("preferences", obj.toMap());

      // Get.snackbar("OK", "Create table ${count}");

      // Get.offNamed('/settings');

      User obj = User(
          2, "depo.ckr", "123", "2", "Depo Cikarang", 1, "User", 1, 1, "-", 1);
      int id = await db.insert("users", obj.toMap());
      Get.snackbar("ID", id.toString());

      List<Map<String, dynamic>> users = await db.query("users");
      print(users.toList());
    } else {
      List<User> users =
          await dbHelper.selectUserToLogin(username.text, password.text);
      if (users.isEmpty) {
        Get.snackbar("Message", "Username and password not found!");
      } else {
        Preferences obj = Preferences(1, "true", "-", "-", "-", "-", 0, "-",
            "-", 0, "-", users[0].roleId, users[0].userId, "-", 0, 0);
        // print(obj.toMap());
        int count = await db.update("preferences", obj.toMap(),
            where: "id = ?", whereArgs: [1]);
        // print(count);
        // List<Map<String, dynamic>> maps = await db.query("preferences");
        // print(maps);
        if (count == 1) {
          Get.offNamed('/home');
        } else {
          Get.snackbar("Info", "Update preferences failed");
        }
      }
    }
  }
}
