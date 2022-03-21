import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/models/preferences.model.dart';

class AppController extends GetxController with StateMixin {
  DbHelper dbHelper = DbHelper();

  @override
  void onInit() {
    // TODO: implement onInit
    checkLogin();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void checkLogin() async {
    final List<Preferences> pref = await dbHelper.initApp();
    if (pref[0].registered == "false") {
      Get.offNamed('/register');
    } else {
      if (pref[0].locationId != 0) {
        Get.offNamed('/home');
      } else {
        Get.offNamed('/login');
      }
    }
  }
}
