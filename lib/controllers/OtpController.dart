import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/models/preferences.model.dart';
import 'package:myasset/services/Register.service.dart';
import 'package:sqflite/sqflite.dart';

class OtpController extends GetxController {
  final box = GetStorage();
  DbHelper dbHelper = DbHelper();

  RegisterService registerService = RegisterService();

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

  void actionResendOtp() async {
    try {
      registerService.resendOtp(args[0], args[4]).then((value) {
        Map body = value.body;
        if (body['message'].toString().isNotEmpty) {
          Get.dialog(
            AlertDialog(
              title: const Text("Warning"),
              content: Text(body['message'].toString()),
            ),
          );
        } else {
          Get.dialog(
            const AlertDialog(
              title: Text("Information"),
              content: Text("OTP has been sended."),
            ),
          );
        }
      });
    } catch (e) {
      Get.dialog(
        const AlertDialog(
          title: Text("Warning"),
          content: Text("Catch Error."),
        ),
      );
    } finally {
      Get.dialog(
        const AlertDialog(
          title: Text("Warning"),
          content: Text("Catch Finally."),
        ),
      );
    }
  }

  void actionSubmitOtp() async {
    try {
      if (args[2] == pin) {
        registerService.checkOtp(args[0], args[1], args[2]).then((value) {
          Map body = value.body;
          if (body['username'].toString().isNotEmpty) {
            Get.dialog(
              AlertDialog(
                title: const Text("Warning"),
                content: Text(body['message'].toString()),
              ),
            );
          } else {
            box.write('registered', true);
            box.write('apiAddress', args[3]);

            box.write('email', args[0]);
            box.write('username', body['username']);
            box.write('encPassword', body['encpassword']);
            box.write('empNo', body['empno']);
            box.write('realName', body['realname']);

            box.write('locationId', args[1]);
            box.write('locationCode', body['locCode']);
            box.write('locationName', body['locName']);

            box.write('instransitId', body['instransitId']);
            box.write('instransitCode', body['instransitCode']);
            box.write('instransitName', body['instransitName']);

            box.write('plantId', body['plantid']);
            box.write('plantName', body['plantName']);

            box.write('roleId', body['roleid']);
            box.write('roleName', body['rolename']);

            Get.offAndToNamed('/login');
          }
        });
      } else {
        Get.dialog(
          const AlertDialog(
            title: Text("Warning"),
            content: Text("OTP not match."),
          ),
        );
      }
    } catch (e) {
      Get.dialog(
        const AlertDialog(
          title: Text("Warning"),
          content: Text("Catch Error."),
        ),
      );
    } finally {
      Get.dialog(
        const AlertDialog(
          title: Text("Warning"),
          content: Text("Catch Finally."),
        ),
      );
    }
  }
}
