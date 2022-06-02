import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:sqflite/sqflite.dart';

class ClearController extends GetxController {
  DbHelper dbHelper = DbHelper();
  final box = GetStorage();

  @override
  // ignore: unnecessary_overrides
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
  }

  @override
  // ignore: unnecessary_overrides
  void onClose() {
    // ignore: todo
    // TODO: implement onClose
    super.onClose();
  }

  void clearAllData(int periodId) async {
    // remove all data table stockopnames
    Database db = await dbHelper.initDb();
    var locationId = box.read('locationId');

    // process to delete all stockopnames
    await db.delete(
      'stockopnames',
      where: "periodId = ? AND locationId = ?",
      whereArgs: [periodId, locationId],
    );

    // process to delete all soconfirms
    await db.delete(
      'soconfirms',
      where: "periodId = ? AND locId = ?",
      whereArgs: [periodId, locationId],
    );

    // process to delete all fatrans and fatransitem
    List<Map<String, dynamic>> periods = await db.query(
      "periods",
      where: "periodId = ?",
      whereArgs: [periodId],
    );
    Map<String, dynamic> getFirst = periods.first;

    // Listing fatrans by startdate and enddate
    List<Map<String, dynamic>> trans = await db.query(
      "fatrans",
      where: "date(transDate) BETWEEN ? AND ?",
      whereArgs: [
        getFirst['startDate'].toString().substring(0, 10),
        getFirst['endDate'].toString().substring(0, 10)
      ],
    );

    for (var item in trans) {
      // delete item trans first
      await db.delete(
        "fatransitem",
        where: "transItemId = ?",
        whereArgs: [item['id']],
      );

      // delete trans
      await db.delete(
        "fatrans",
        where: "id = ?",
        whereArgs: [item['id']],
      );
    }

    Get.dialog(
      const AlertDialog(
        title: Text("Information"),
        content: Text("Data has been cleared."),
      ),
    );
  }
}
