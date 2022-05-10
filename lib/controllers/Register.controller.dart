import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/services/Register.service.dart';
import 'package:platform_device_id/platform_device_id.dart';

class RegisterController extends GetxController {
  final box = GetStorage();
  DbHelper dbHelper = DbHelper();
  RegisterService registerService = RegisterService();

  var isAt = false.obs;

  TextEditingController apiAddress = TextEditingController();
  TextEditingController locationId = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController deviceId = TextEditingController();

  @override
  void onInit() async {
    // TODO: implement onInit
    deviceId.text = (await PlatformDeviceId.getDeviceId)!;
    apiAddress.text = box.read('apiAddress') ?? "https://api.sariroti.com";
    locationId.text = box.read('locationId') ?? "";
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void checkFirstCharacterEmail(String value) {
    isAt.value = value == '@' ? true : false;
  }

  void toOtpScreen() {
    try {
      if (email.text.isNotEmpty) {
        registerService.register(email.text, deviceId.text).then((value) {
          Map body = value.body;
          if (body['message'].toString().isNotEmpty) {
            Get.dialog(
              AlertDialog(
                title: const Text("Warning"),
                content: Text(body['message'].toString()),
              ),
            );
          } else {
            Get.toNamed(
              '/otp',
              arguments: [
                email.text,
                body['locationId'],
                body['otp'],
                apiAddress.text,
                deviceId.text,
              ],
            );
          }
        });
      } else {
        Get.dialog(
          const AlertDialog(
            title: Text("Warning"),
            content: Text("All field must be filled."),
          ),
        );
      }
    } catch (e) {
      Get.dialog(
        const AlertDialog(
          title: Text("Message"),
          content: Text("Catch Error"),
        ),
      );
    } finally {
      Get.dialog(
        const AlertDialog(
          title: Text("Message"),
          content: Text("Finally"),
        ),
      );
    }
  }
}
