import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/services/FAItem.service.dart';
import 'package:myasset/services/FASOHead.service.dart';
import 'package:myasset/services/FATrans.service.dart';
import 'package:myasset/services/FATransItem.service.dart';
import 'package:myasset/services/Location.service.dart';
import 'package:myasset/services/Period.service.dart';
import 'package:myasset/services/Status.service.dart';
import 'package:myasset/services/Stockopname.service.dart';
import 'package:myasset/services/User.service.dart';
import 'package:sqflite/sqlite_api.dart';

class DownloadController extends GetxController {
  DbHelper dbHelper = DbHelper();
  var isStart = false.obs;
  var listProgress = <Widget>[].obs;
  final box = GetStorage();

  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // ignore: todo
    // TODO: implement onClose
    super.onClose();
  }

  void confirmDownload() {
    Get.dialog(
      AlertDialog(
        title: const Text("Confirmation"),
        content: const Text("Are you sure to download data ?"),
        actions: [
          TextButton(
            onPressed: () {
              // to do action in here
              startDownload();
              Get.back();
            },
            child: const Text("YES"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("NO"),
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

    listProgress.add(rowProgress("Downloading Master Data."));

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
          "syncBy": box.read('username')
        };
        await db.insert("statuses", map);
      }
    });
    listProgress.add(rowProgress("Table status completed."));

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
          "syncBy": box.read('username')
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
          "syncBy": box.read('username')
        };
        await db.insert(
          "faitems",
          map,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
    listProgress.add(rowProgress("Table faitems completed."));

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
          "syncBy": box.read('username')
        };
        await db.insert("periods", map);
      }
    });
    listProgress.add(rowProgress("Table period completed."));

    // Process stockopanme by period id
    var soService = StockopnameService();
    listProgress.add(rowProgress("Sync table stockopname."));
    await soService.getAll().then((value) async {
      List lists = value.body['list'];
      for (var row in lists) {
        List<Map<String, dynamic>> rows = await db.query(
          'stockopnames',
          where: "stockOpnameId = ?",
          whereArgs: [
            row['stockOpnameId'],
          ],
        );

        Map<String, dynamic> map = {};
        if (rows.isNotEmpty) {
          // action update
          map['faId'] = row['faId'];
          map['periodId'] = row['periodId'];
          map['stockOpnameId'] = row['stockOpnameId'];
          map['tagNo'] = row['tagNo'];
          map['description'] = row['itemName'];
          map['locationId'] = box.read('locationId');
          map['qty'] = row['qty'];
          map['periodId'] = row['periodId'];
          map['baseQty'] = row['baseQty'];
          map['baseConStatCode'] = row['baseConStat'];
          map['existStatCode'] = row['existStat'];
          map['tagStatCode'] = row['tagStat'];
          map['usageStatCode'] = row['usageStat'];
          map['conStatCode'] = row['conStat'];
          map['ownStatCode'] = row['ownStat'];
          map['rejectNote'] = row['rejectNote'];
          map['syncDate'] =
              DateFormat("yyyy-MM-dd kk:mm").format(DateTime.now());
          map['syncBy'] = box.read('userId');
          await db.update(
            "stockopnames",
            map,
            where: "stockOpnameId = ?",
            whereArgs: [
              row['stockOpnameId'],
            ],
          );
          listProgress.add(rowProgress("ID ${row['stockOpnameId']} updated."));
        } else {
          // action insert
          map['faId'] = row['faId'];
          map['periodId'] = row['periodId'];
          map['stockOpnameId'] = row['stockOpnameId'];
          map['tagNo'] = row['tagNo'];
          map['description'] = row['itemName'];
          map['locationId'] = box.read('locationId');
          map['qty'] = row['qty'];
          map['baseQty'] = row['baseQty'];
          map['baseConStatCode'] = row['baseConStat'];
          map['existStatCode'] = row['existStat'];
          map['tagStatCode'] = row['tagStat'];
          map['usageStatCode'] = row['usageStat'];
          map['conStatCode'] = row['conStat'];
          map['ownStatCode'] = row['ownStat'];
          map['rejectNote'] = row['rejectNote'];
          map['syncDate'] =
              DateFormat("yyyy-MM-dd kk:mm").format(DateTime.now());
          map['syncBy'] = box.read('userId');
          var id = await db.insert(
            "stockopnames",
            map,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          listProgress.add(rowProgress("ID $id inserted."));
        }
      }
    });
    listProgress.add(rowProgress("Table stockopname completed."));

    var locService = LocationService();
    listProgress.add(rowProgress("Sync table locations."));
    await db.delete("locations", where: null);
    await locService.getAll().then((value) async {
      List periods = value.body['locs'];
      for (var i = 0; i < periods.length; i++) {
        listProgress
            .add(rowProgress("ID ${periods[i]['locationId']} inserted."));
        Map<String, dynamic> map = {
          "locationId": periods[i]['locationId'],
          "locationCode": periods[i]['locationCode'],
          "description": periods[i]['description'],
          "locTypeCode": periods[i]['locTypeCode'],
          "intransitId": periods[i]['intransitId'],
          "plantId": periods[i]['plantId'],
          "entityCode": periods[i]['entityCode'],
          "contactPerson": periods[i]['contactPerson'],
          "address": periods[i]['address'],
          "city": periods[i]['city'],
          "state": periods[i]['state'],
          "phones": periods[i]['phones'],
          "fax": periods[i]['fax'],
          "email": periods[i]['email'],
          "insertDate": periods[i]['insertDate'],
          "insertBy": periods[i]['insertBy']
        };
        await db.insert("locations", map,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
    listProgress.add(rowProgress("Table locations completed."));

    var fasoheadService = FASOHeadService();
    listProgress.add(rowProgress("Sync table fasohead."));
    await db.delete("fasohead", where: null);
    await fasoheadService.getAll().then((value) async {
      List periods = value.body['list'];
      for (var i = 0; i < periods.length; i++) {
        listProgress.add(rowProgress("ID ${periods[i]['soHeadId']} inserted."));
        Map<String, dynamic> map = {
          "soHeadId": periods[i]['soHeadId'],
          "periodId": periods[i]['periodId'],
          "locationId": periods[i]['locationId'],
          "soStatusCode": periods[i]['soStatusCode'],
          "rejectNote": periods[i]['rejectNote'],
          "syncDate": DateFormat("yyyy-MM-dd kk:mm").format(DateTime.now()),
          "syncBy": box.read('userId')
        };
        await db.insert(
          "fasohead",
          map,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
    listProgress.add(rowProgress("Table fasohead completed."));

    var transService = FATransService();
    var transItemService = FATransItemService();
    var response = await transItemService.getAll();
    var responseBody = response.body;
    listProgress.add(rowProgress("Sync table FA Trans."));
    // await db.delete("fatrans", where: null);
    await transService.getAll().then((value) async {
      List periods = value.body['fatrans'];
      for (var i = 0; i < periods.length; i++) {
        listProgress.add(rowProgress("ID ${periods[i]['transId']} inserted."));

        List<Map<String, dynamic>> sFa = await db.query(
          'fatrans',
          where: "transId = ?",
          whereArgs: [periods[i]['transId']],
        );

        Map<String, dynamic> map = {
          "transId": periods[i]['transId'],
          "plantId": periods[i]['plantId'],
          "transTypeCode": periods[i]['transTypeCode'],
          "transDate": periods[i]['transDate'].toString().replaceAll('T', ' '),
          "transNo": periods[i]['transNo'],
          "manualRef": periods[i]['manualRef'],
          "otherRef": periods[i]['otherRef'],
          "transferTypeCode": periods[i]['transferTypeCode'],
          "oldLocId": periods[i]['oldLocId'],
          "oldLocCode": "",
          "oldLocName": "",
          "newLocId": periods[i]['newLocId'],
          "newLocCode": "",
          "newLocName": "",
          "isApproved": periods[i]['isApproved'] ? 1 : 0,
          "isVoid": periods[i]['isVoid'] ? 1 : 0,
          "saveDate": periods[i]['insertDate'],
          "savedBy": periods[i]['insertBy'],
          "syncDate": DateFormat("yyyy-MM-dd kk:mm").format(DateTime.now()),
          "syncBy": box.read('userId')
        };

        if (sFa.length == 1) {
          // action update
          var getTransId = sFa.first['transId'];
          await db.update(
            'fatrans',
            map,
            where: 'transId = ?',
            whereArgs: [periods[i]['transId']],
          );

          // List<dynamic> getTransItems = responseBody['transitems'];
          // List filtered = getTransItems
          //     .where((element) => element['transId'] == getTransId)
          //     .toList();
          // for (var item in filtered) {
          //   List<Map<String, dynamic>> getFaTransItems = await db.query(
          //     'fatransitem',
          //     where: 'transId = ?',
          //     whereArgs: [item['transId']],
          //   );
          //   Map<String, dynamic> map = {
          //     "transItemId": item['transItemId'],
          //     "transId": item['transId'],
          //     "faId": item['faId'],
          //     "qty": item['qty'],
          //     "remarks": item['remarks'],
          //     "conStatCode": item['conStatCode'],
          //     "tagNo": item['oldTagNo'],
          //     "oldTagNo": item['oldTagNo'],
          //     "newTagNo": item['newTagNo'],
          //     "saveDate": item['insertDate'],
          //     "saveBy": item['insertBy'],
          //     "syncDate": DateFormat("yyyy-MM-dd kk:mm").format(DateTime.now()),
          //     "syncBy": box.read('userId')
          //   };
          //   if (getFaTransItems.isNotEmpty) {
          //     map['transLocalId'] = getFaTransItems.first['transLocalId'];
          //     await db.update(
          //       'fatransitem',
          //       map,
          //       where: 'transId = ?',
          //       whereArgs: [item['transId']],
          //     );
          //   } else {
          //     map['transLocalId'] = sFa.first['transLocalId'];
          //     await db.insert(
          //       'fatransitem',
          //       map,
          //       conflictAlgorithm: ConflictAlgorithm.replace,
          //     );
          //   }
          // }
        } else {
          var getTransId = await db.insert(
            "fatrans",
            map,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );

          // List<dynamic> getTransItems = response.body['transitems'];
          // List<dynamic> filtered = getTransItems
          //     .where((element) => element['transId'] == getTransId)
          //     .toList();
          // for (var item in filtered) {
          //   List<Map<String, dynamic>> getFaTransItems = await db.query(
          //     'fatransitem',
          //     where: 'transId = ?',
          //     whereArgs: [item['transId']],
          //   );
          //   Map<String, dynamic> map = {
          //     "transItemId": item['transItemId'],
          //     "transId": item['transId'],
          //     "faId": item['faId'],
          //     "qty": item['qty'],
          //     "remarks": item['remarks'],
          //     "conStatCode": item['conStatCode'],
          //     "tagNo": item['oldTagNo'],
          //     "oldTagNo": item['oldTagNo'],
          //     "newTagNo": item['newTagNo'],
          //     "saveDate": item['insertDate'],
          //     "saveBy": item['insertBy'],
          //     "syncDate": DateFormat("yyyy-MM-dd kk:mm").format(DateTime.now()),
          //     "syncBy": box.read('userId')
          //   };
          //   if (getFaTransItems.isNotEmpty) {
          //     map['transLocalId'] = getFaTransItems.first['transLocalId'];
          //     await db.update(
          //       'fatransitem',
          //       map,
          //       where: 'transId = ?',
          //       whereArgs: [item['transId']],
          //     );
          //   } else {
          //     map['transLocalId'] = getTransId;
          //     await db.insert(
          //       'fatransitem',
          //       map,
          //       conflictAlgorithm: ConflictAlgorithm.replace,
          //     );
          //   }
          // }
        }
      }
    });
    listProgress.add(rowProgress("Table FA Trans completed."));

    listProgress.add(rowProgress("Sync table FA Trans Item."));
    await db.delete("fatransitem", where: null);
    await transItemService.getAll().then((value) async {
      List periods = value.body['transitems'];
      for (var i = 0; i < periods.length; i++) {
        listProgress
            .add(rowProgress("ID ${periods[i]['transItemId']} inserted."));
        Map<String, dynamic> map = {
          "transItemId": periods[i]['transItemId'],
          "transId": periods[i]['transId'],
          // "faItemId": INTEGER,
          "faId": periods[i]['faId'],
          // "faNo": INTEGER,
          // "description": TEXT,
          "remarks": periods[i]['remarks'],
          "conStatCode": periods[i]['conStatCode'],
          "tagNo": periods[i]['oldTagNo'],
          "saveDate": periods[i]['insertDate'],
          "saveBy": periods[i]['insertBy'],
          "syncDate": DateFormat("yyyy-MM-dd kk:mm").format(DateTime.now()),
          "syncBy": box.read('userId')
        };
        await db.insert("fatransitem", map);
      }
    });
    listProgress.add(rowProgress("Table FA Trans Item completed."));
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
