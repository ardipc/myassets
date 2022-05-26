import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/services/FAItem.service.dart';
import 'package:myasset/services/Period.service.dart';
import 'package:myasset/services/Status.service.dart';
import 'package:myasset/services/User.service.dart';
import 'package:sqflite/sqlite_api.dart';

class DownloadController extends GetxController {
  DbHelper dbHelper = DbHelper();
  var isStart = false.obs;
  var listProgress = <Widget>[].obs;
  final box = GetStorage();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print("init download ${box.read('userId')}");
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    print("close download");
  }

  void confirmDownload() {
    Get.dialog(
      AlertDialog(
        title: Text("Confirmation"),
        content: Text("Are you sure to clear data ?"),
        actions: [
          TextButton(
            onPressed: () {
              // to do action in here
              startDownload();
              Get.back();
            },
            child: Text("YES"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("NO"),
          ),
        ],
      ),
    );
  }

  void restart() async {
    isStart.value = false;
    listProgress.clear();
  }

  Future<void> startDownload() async {
    isStart.value = true;
    Database db = await dbHelper.initDb();

    var statusService = StatusService();
    listProgress.add(rowProgress("Sync table status."));
    await db.delete("statuses", where: null);
    await statusService.getAll().then((value) async {
      List statuses = value.body['statuses'];
      for (var i = 0; i < statuses.length; i++) {
        listProgress.add(rowProgress("ID ${statuses[i]['genId']} inserted."));
        Map<String, dynamic> map = {
          "genId": statuses[i]['gendId'],
          "genCode": statuses[i]['genCode'],
          "genName": statuses[i]['genName'],
          "genGroup": statuses[i]['genGroup'],
          "sort": statuses[i]['sort'],
          "syncDate": DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now()),
          "syncBy": box.read('userId')
        };
        await db.insert("statuses", map);
      }
    });
    listProgress.add(rowProgress("Table status completed."));

    var periodService = PeriodService();
    listProgress.add(rowProgress("Sync table period."));
    await db.delete("periods", where: null);
    await periodService.getAll().then((value) async {
      List periods = value.body['periods'];
      for (var i = 0; i < periods.length; i++) {
        listProgress.add(rowProgress("ID ${periods[i]['periodId']} inserted."));
        Map<String, dynamic> map = {
          "periodId": periods[i]['periodId'],
          "periodName": periods[i]['periodName'],
          "startDate": periods[i]['startDate'],
          "endDate": periods[i]['endDate'],
          "closeActualDate": periods[i]['closeActualDate'],
          "soStartDate": periods[i]['soStartDate'],
          "soEndDate": periods[i]['soEndDate'],
          "syncDate": DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now()),
          "syncBy": box.read('userId')
        };
        await db.insert("periods", map);
      }
    });
    listProgress.add(rowProgress("Table period completed."));

    var userService = UserService();
    listProgress.add(rowProgress("Sync table users."));
    await db.delete("users", where: null);
    await userService.getAll().then((value) async {
      List users = value.body['users'];
      for (var i = 0; i < users.length; i++) {
        listProgress.add(rowProgress("ID ${users[i]['userId']} inserted."));
        Map<String, dynamic> map = {
          "userId": users[i]['userId'],
          "username": users[i]['username'],
          "password": users[i]['password'],
          "empNo": users[i]['empNo'],
          "realName": users[i]['realName'],
          "roleId": users[i]['roleId'],
          "roleName": '-',
          "plantId": users[i]['plantId'],
          "locationId": users[i]['locationId'],
          "syncDate": DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now()),
          "syncBy": box.read('userId')
        };
        await db.insert("users", map);
      }
    });
    listProgress.add(rowProgress("Table users completed."));

    var faItemService = FAItemService();
    listProgress.add(rowProgress("Sync table faitems."));
    await db.delete("faitems", where: null);
    await faItemService.getAll().then((value) async {
      List users = value.body['faitems'];
      for (var i = 0; i < users.length; i++) {
        listProgress.add(rowProgress("ID ${users[i]['faId']} inserted."));
        Map<String, dynamic> map = {
          "faId": users[i]['faId'],
          "faNo": users[i]['faNo'],
          "tagNo": users[i]['tagNo'],
          "assetName": users[i]['assetName'],
          "locId": users[i]['locationId'],
          "added": users[i]['added'],
          "disposed": users[i]['disposed'],
          "syncDate": DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now()),
          "syncBy": box.read('userId')
        };
        await db.insert("faitems", map);
      }
    });
    listProgress.add(rowProgress("Table faitems completed."));
  }

  Widget rowProgress(String text) {
    return Row(
      children: [
        Expanded(
          child: Text(text),
        ),
        SizedBox(
          width: 40,
          child: IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              Get.snackbar("Information", "Copy to Clipboard.");
            },
            icon: const Icon(Icons.copy),
          ),
        ),
      ],
    );
  }
}
