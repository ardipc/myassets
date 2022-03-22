import 'package:get/get.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/models/preferences.model.dart';
import 'package:sqflite/sqflite.dart';

class OtpController extends GetxController {
  DbHelper dbHelper = DbHelper();

  dynamic args = Get.arguments;
  String pin = "";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void changePin(String v) {
    pin = v;
  }

  void actionSubmitOtp() async {
    Get.offAllNamed('/home');
    Get.snackbar(
      "OTP",
      pin,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
