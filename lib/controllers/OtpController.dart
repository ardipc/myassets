import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/models/preferences.model.dart';
import 'package:sqflite/sqflite.dart';

class OtpController extends GetxController {
  final box = GetStorage();
  DbHelper dbHelper = DbHelper();

  dynamic args = Get.arguments;
  String pin = "";

  String onlyPin = "12312";

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
    if (onlyPin == pin) {
      box.write('registered', true);
      box.write('apiAddress', args[0]);
      box.write('locationId', args[1]);
      Get.offAndToNamed('/login');
    } else {
      Get.dialog(
        const AlertDialog(
          title: Text("Warning"),
          content: Text("OTP not match."),
        ),
      );
    }
  }
}
