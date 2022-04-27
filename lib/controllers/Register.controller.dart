import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:platform_device_id/platform_device_id.dart';

class RegisterController extends GetxController {
  final box = GetStorage();
  DbHelper dbHelper = DbHelper();

  TextEditingController apiAddress = TextEditingController();
  TextEditingController locationId = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController deviceId = TextEditingController();

  @override
  void onInit() async {
    // TODO: implement onInit
    deviceId.text = (await PlatformDeviceId.getDeviceId)!;
    apiAddress.text = box.read('apiAddress') ?? "";
    locationId.text = box.read('locationId') ?? "";
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void toOtpScreen() {
    if (apiAddress.text.isNotEmpty &&
        locationId.text.isNotEmpty &&
        username.text.isNotEmpty &&
        email.text.isNotEmpty) {
      Get.toNamed(
        '/otp',
        arguments: [
          apiAddress.text,
          locationId.text,
          username.text,
          email.text,
          deviceId.text
        ],
      );
    } else {
      Get.dialog(
        const AlertDialog(
          title: Text("Warning"),
          content: Text("All field must be filled."),
        ),
      );
    }
  }
}
