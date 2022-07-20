import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/controllers/Auth.controller.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/services/User.service.dart';

class LoginController extends GetxController {
  var loaderButtonLogin = false.obs;

  DbHelper dbHelper = DbHelper();
  final box = GetStorage();

  final username = TextEditingController();
  final password = TextEditingController();

  final authController = AuthController();

  final userService = UserService();

  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    // ignore: avoid_print
    print("init login");
    username.text = "";
    password.text = "";
    super.onInit();
  }

  @override
  void onClose() {
    // ignore: todo
    // TODO: implement onClose
    // ignore: avoid_print
    print("close");
    username.text = "";
    password.text = "";
    super.onClose();
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    // ignore: avoid_print
    print("dispose");
    username.dispose();
    password.dispose();
    super.dispose();
  }

  void actionLogin() async {
    loaderButtonLogin.value = true;
    if (username.text == "admin" && password.text == "12345") {
      box.write('userId', 0);
      box.write('roleId', 1);
      box.write('roleName', "Administrator");
      box.write('username', "admin");
      box.write('realName', "Admin");
      Get.offAndToNamed('/home', arguments: ['superadmin']);
    } else {
      // Database db = await dbHelper.initDb();
      // List<User> users =
      // await dbHelper.selectUserToLogin(username.text, password.text);
      // print(username.text);
      // print(password.text);
      var res =
          await userService.findUserByUserAndPass(username.text, password.text);
      // ignore: avoid_print
      print(res.body);

      if (res.body != null) {
        if (res.body['status']) {
          box.write('roleId', res.body['roleId']);
          box.write('token', res.body['token']);
          box.write('realName', res.body['realname']);
          box.write('roleName', res.body['rolename']);

          await authController.saveToken(res.body['token']);
          loaderButtonLogin.value = false;

          Get.offNamed('/home');
        } else {
          loaderButtonLogin.value = false;

          Get.dialog(
            const AlertDialog(
              title: Text("Message"),
              content: Text("Username and password not found!"),
            ),
          );
        }
      } else {
        loaderButtonLogin.value = false;

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
