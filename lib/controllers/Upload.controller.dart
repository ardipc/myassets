import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/services/FASOHead.service.dart';
import 'package:myasset/services/FATrans.service.dart';
import 'package:myasset/services/FATransItem.service.dart';
import 'package:myasset/services/Stockopname.service.dart';
import 'package:sqflite/sqlite_api.dart';

class UploadController extends GetxController {
  DbHelper dbHelper = DbHelper();
  var isStart = false.obs;
  var listProgress = <Widget>[].obs;
  final box = GetStorage();

  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    // ignore: avoid_print
    print("init download ${box.read('username')}");
  }

  @override
  void onClose() {
    // ignore: todo
    // TODO: implement onClose
    super.onClose();
    // ignore: avoid_print
    print("close download");
  }

  void confirmDownload() {
    Get.dialog(
      AlertDialog(
        title: const Text("Confirmation"),
        content: const Text("Are you sure to upload data ?"),
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
    final box = GetStorage();
    isStart.value = true;
    Database db = await dbHelper.initDb();
    listProgress.add(rowProgress("Starting upload data."));

    listProgress.add(rowProgress("Uploading Stock Opname data..."));
    List<Map<String, dynamic>> soRows = await db.query(
      'stockopnames',
      where: "uploadDate IS NULL OR uploadDate = ? OR uploadDate <= syncDate",
      whereArgs: [''],
    );

    var soService = StockopnameService();
    for (var data in soRows) {
      Map<String, dynamic> map = {};
      map['stockOpnameId'] = data['stockOpnameId'];
      map['periodId'] = data['periodId'];
      map['faId'] = data['faId'];
      map['locationId'] = data['locationId'];
      map['qty'] = data['qty'];
      map['existStatCode'] = data['existStatCode'];
      map['tagStatCode'] = data['tagStatCode'];
      map['usageStatCode'] = data['usageStatCode'];
      map['conStatCode'] = data['conStatCode'];
      map['ownStatCode'] = data['ownStatCode'];
      soService.createStockopname(map).then((value) async {
        var res = value.body;
        // ignore: avoid_print
        // print(res);
        if (res['message'] == '') {
          Map<String, dynamic> m = {};
          m['stockOpnameId'] = res['stockOpnameId'];
          m['uploadDate'] =
              DateFormat("yyyy-MM-dd kk:mm").format(DateTime.now());
          m['uploadBy'] = box.read('username');
          m['uploadMessage'] = res['message'];
          await db.update(
            "stockopnames",
            m,
            where: "id = ?",
            whereArgs: [
              data['id'],
            ],
          );
          listProgress.add(
              rowProgress("ID ${res['stockOpnameId'].toString()} uploaded."));
        }
      });
    }

    listProgress.add(rowProgress("Uploading FASOHead data..."));
    var fasoheadService = FASOHeadService();
    List<Map<String, dynamic>> fasoRows = await db.query('fasohead');
    for (var data in fasoRows) {
      listProgress
          .add(rowProgress("Uploading FASOHead ID ${data['soHeadId']}..."));

      Map<String, dynamic> map = {
        "soHeadId": data['soHeadId'],
        "statusCode": data['soStatusCode'],
        "userId": box.read('userId'),
      };
      fasoheadService.create(map).then((value) async {
        var res = value.body;
        listProgress.add(rowProgress(res['message'] != ""
            ? res['message']
            : "FASOHeadID ${data['soHeadId']} uploaded..."));
      });
    }

    listProgress.add(rowProgress("Uploading Transaction data..."));
    List<Map<String, dynamic>> transRows = await db.query('fatrans',
        where:
            "uploadDate IS NULL OR uploadDate = '' OR uploadDate <= syncDate");
    var faTransService = FATransService();
    var faTransItemService = FATransItemService();
    for (var data in transRows) {
      listProgress
          .add(rowProgress("Uploading Transaction ID ${data['id']}..."));
      List<Map<String, dynamic>> transItemRows = await db
          .query('fatransitem', where: "transId = ?", whereArgs: [data['id']]);
      for (var r in transItemRows) {
        listProgress
            .add(rowProgress("Uploading Item Transaction ID ${data['id']}..."));
        Map<String, dynamic> m = {};
        m['transId'] = data['id'];
        m['faId'] = r['faId'];
        m['remarks'] = r['remarks'];
        m['conStat'] = r['conStat'];
        m['oldTag'] = r['oldTag'];
        m['newTag'] = r['newTag'];
        m['userId'] = box.read('username');

        faTransItemService.create(m).then((value) async {
          var res = value.body;
          if (res['message'].toString().isNotEmpty) {
            Map<String, dynamic> mu = {};
            m['transItemId'] = res['transItemId'];
            m['uploadDate'] =
                DateFormat("yyyy-MM-dd kk:mm").format(DateTime.now());
            m['uploadBy'] = box.read('username');
            m['uploadMessage'] = res['message'];
            await db.update(
              'fatransitem',
              mu,
              where: "id = ?",
              whereArgs: [r['id']],
            );
          }
        });
      }

      Map<String, dynamic> map = {};
      map['plantId'] = data['plantId'];
      map['transDate'] = data['transDate'];
      map['manualRef'] = data['manualRef'];
      map['otherRef'] = data['otherRef'];
      map['transferType'] = data['transferType'];
      map['oldLocId'] = data['oldLocId'];
      map['newLocId'] = data['newLocId'];
      map['isApproved'] = data['isApproved'] == 1 ? true : false;
      map['isVoid'] = data['isVoid'] == 1 ? true : false;
      map['userId'] = box.read('username');

      faTransService.create(map).then((value) async {
        var res = value.body;
        if (res['message'].toString().isNotEmpty) {
          Map<String, dynamic> m = {};
          m['transId'] = res['transId'];
          m['uploadDate'] =
              DateFormat("yyyy-MM-dd kk:mm").format(DateTime.now());
          m['uploadBy'] = box.read('username');
          m['uploadMessage'] = res['message'];
          await db.update(
            "fatrans",
            m,
            where: "id = ?",
            whereArgs: [
              data['id'],
            ],
          );
          listProgress.add(
              rowProgress("ID ${res['stockOpnameId'].toString()} uploaded."));
        }
      });
    }

    listProgress.add(rowProgress("Upload data is complete."));
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
