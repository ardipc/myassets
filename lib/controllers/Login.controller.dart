import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/controllers/Auth.controller.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/models/preferences.model.dart';
import 'package:myasset/models/user.model.dart';
import 'package:myasset/services/User.service.dart';
import 'package:sqflite/sqlite_api.dart';

class LoginController extends GetxController {
  DbHelper dbHelper = DbHelper();
  final box = GetStorage();

  final username = TextEditingController();
  final password = TextEditingController();

  final authController = AuthController();

  final userService = UserService();

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
    if (username.text == "admin" && password.text == "123") {
      Get.offAndToNamed('/home', arguments: ['superadmin']);
    } else {
      // Database db = await dbHelper.initDb();
      // List<User> users =
      // await dbHelper.selectUserToLogin(username.text, password.text);

      var res =
          await userService.findUserByUserAndPass(username.text, password.text);

      if (res.body != null) {
        if (res.body['status']) {
          box.write('roleId', res.body['roleId']);
          box.write('token', res.body['token']);

          await authController.saveToken(res.body['token']);

          Get.offNamed('/home');
        } else {
          Get.dialog(
            const AlertDialog(
              title: Text("Message"),
              content: Text("Username and password not found!"),
            ),
          );
        }
      } else {
        Get.dialog(
          const AlertDialog(
            title: Text("Message"),
            content: Text("Please check your connection network."),
          ),
        );
      }

      // Digunain jika offline
      // if (users.isEmpty) {
      //   // Get.snackbar("Message", "Username and password not found!");
      //   Get.dialog(
      //     const AlertDialog(
      //       title: Text("Message"),
      //       content: Text("Username and password not found!"),
      //     ),
      //   );
      // } else {
      //   box.write('userId', users[0].userId);
      //   box.write('username', username.text);
      //   box.write('roleId', users[0].roleId);
      //   box.write('roleName', users[0].roleName);
      //   box.write('realName', users[0].realName);
      //   Get.offNamed('/home');
      // }
    }
  }

  void actionLogout() async {
    final box = GetStorage();
    box.remove('email');
    box.remove('username');
    box.remove('encPassword');
    box.remove('empNo');
    box.remove('realName');

    box.remove('locationId');
    box.remove('locationCode');
    box.remove('locationName');

    box.remove('instransitId');
    box.remove('instransitCode');
    box.remove('instransitName');

    box.remove('plantId');
    box.remove('plantName');

    box.remove('roleId');
    box.remove('roleName');

    Get.offAllNamed('/login');
  }
}
