import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
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
        print(value.body);
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
    }
  }

  void actionSubmitOtp() async {
    Database db = await dbHelper.initDb();

    try {
      if (args[2] == pin) {
        registerService
            .checkOtp(
                args[0].toString(), args[1].toString(), args[2].toString())
            .then((value) async {
          print(value.body);
          Map body = value.body;
          if (body['username'].toString() == "") {
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
              "password": body['encpassword'],
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
