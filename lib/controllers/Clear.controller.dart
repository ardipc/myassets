import 'package:get/get.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:sqflite/sqflite.dart';

class ClearController extends GetxController {
  DbHelper dbHelper = DbHelper();

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

    await db
        .delete('stockopnames', where: "periodId = ?", whereArgs: [periodId]);
    await db.delete('soconfirms', where: "periodId = ?", whereArgs: [periodId]);
  }
}
