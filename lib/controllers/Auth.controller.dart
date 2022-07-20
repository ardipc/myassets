import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/cache.helper.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/services/User.service.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:sqflite/sqlite_api.dart';

class AuthController extends GetxController with CacheManager {
  final isLogged = false.obs;
  DbHelper dbHelper = DbHelper();

  void actionUnregister() async {
    isLogged.value = false;

    final box = GetStorage();
    box.remove('userId');
    box.remove('username');
    box.remove('roleId');
    box.remove('roleName');
    box.remove('realName');

    removeToken();

    var userService = UserService();
    var deviceId = (await PlatformDeviceId.getDeviceId)!;
    userService.unRegister(box.read('email'), deviceId).then((value) async {
      // print(value.body.toString());
      await emptyAllDatabase();
      Get.offAllNamed('/register');
    });
  }

  Future<void> emptyAllDatabase() async {
    Database db = await dbHelper.initDb();
    await db.delete("periods", where: null);
    await db.delete("users", where: null);
    await db.delete("statuses", where: null);
    await db.delete("faitems", where: null);
    await db.delete("soconfirms", where: null);
    await db.delete("stockopnames", where: null);
    await db.delete("fatrans", where: null);
    await db.delete("fatransitem", where: null);
    await db.delete("locations", where: null);
    await db.delete("fasohead", where: null);
  }

  void actionLogin() {
    isLogged.value = true;
  }

  void checkLogin() async {
    final token = getToken();
    if (token != null) {
      isLogged.value = true;
    }
  }

  void actionLogout() async {
    isLogged.value = false;

    final box = GetStorage();
    // box.remove('userId');
    // box.remove('username');
    // box.remove('roleId');
    box.remove('roleName');
    box.remove('realName');

    removeToken();

    Get.offAllNamed('/login');
  }

  void actionConfirmUnregister() {
    Get.dialog(
      AlertDialog(
        title: const Text("Confirmation"),
        content: const Text("Are you sure to unregister this device?"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              actionUnregister();
            },
            child: const Text("YES"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("NO"),
          ),
        ],
      ),
    );
  }
}
