import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:myasset/controllers/Auth.controller.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/services/Register.service.dart';
import 'package:sqflite/sqflite.dart';

class OtpController extends GetxController {
  final box = GetStorage();
  DbHelper dbHelper = DbHelper();

  RegisterService registerService = RegisterService();
  var authController = AuthController();

  dynamic args = Get.arguments;
  var pin = "".obs;

  void changePin(var v) {
    pin.value = v;
  }

  void actionResendOtp() async {
    try {
      registerService.resendOtp(args[0], args[4]).then((value) {
        // ignore: avoid_print
        print(value.body);
        Map body = value.body;
        if (body['message'].toString().isNotEmpty) {
          pin.value = "";
          Get.dialog(
            AlertDialog(
              title: const Text("Warning"),
              content: Text(body['message'].toString()),
            ),
          );
        } else {
          pin.value = "";
          Get.dialog(
            const AlertDialog(
              title: Text("Information"),
              content: Text("OTP has been sended."),
            ),
          );
        }
      });
    } catch (e) {
      pin.value = "";
      Get.dialog(
        const AlertDialog(
          title: Text("Warning"),
          content: Text("Catch Error."),
        ),
      );
    }
  }

  void actionSubmitOtp() async {
    Database db = await dbHelper.initDb();

    try {
      registerService
          .checkOtp(args[0].toString(), args[1].toString(), pin.value)
          .then((value) async {
        // ignore: avoid_print
        print(value.body);
        Map body = value.body;
        if (body['message'] != "") {
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

          box.write('intransitId', body['intransitId']);
          box.write('intransitCode', body['intransitCode']);
          box.write('intransitName', body['intransitName']);

          box.write('plantId', body['plantid']);
          box.write('plantName', body['plantName']);

          box.write('roleId', body['roleid']);
          box.write('roleName', body['rolename']);

          Map<String, dynamic> map = {
            "username": body['username'],
            "password": body['password'],
            "empNo": body['empno'],
            "realName": body['realname'],
            "roleId": body['roleid'],
            "roleName": body['rolename'],
            "plantId": body['plantid'],
            "locationId": args[1],
            "syncDate": DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now()),
            "syncBy": 0
          };
          await db.insert("users", map);

          await authController.saveToken(body['token']);

          Get.offAndToNamed('/login');
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
      Get.dialog(
        const AlertDialog(
          title: Text("Warning"),
          content: Text("Catch Error."),
        ),
      );
    }
  }
}
