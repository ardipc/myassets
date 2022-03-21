import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:platform_device_id/platform_device_id.dart';

class RegisterController extends GetxController {
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
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void toOtpScreen() {
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
  }
}
