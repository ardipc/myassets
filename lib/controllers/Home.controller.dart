import 'package:get/get.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/models/preferences.model.dart';
import 'package:myasset/models/user.model.dart';
import 'package:sqflite/sqlite_api.dart';

class HomeController extends GetxController {
  DbHelper dbHelper = DbHelper();

  late List<Preferences> prefs = <Preferences>[];
  User? user;

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void getData() async {
    Database db = await dbHelper.initDb();
    List<Preferences> pref = await dbHelper.initApp();
    prefs = pref;

    print(pref);

    List<Map<String, dynamic>> users = await db
        .query("users", where: "userId = ?", whereArgs: [pref[0].userId]);
    user = User.fromMap(users[0]);
  }

  void actionLogout() async {
    Database db = await dbHelper.initDb();

    Preferences obj = Preferences(
        1, "true", "-", "-", "-", "-", 0, "-", "-", 0, "-", 0, 0, "-", 0, 0);

    int count = await db
        .update("preferences", obj.toMap(), where: "id = ?", whereArgs: [1]);

    if (count == 1) {
      Get.offAllNamed('/login');
    } else {
      Get.snackbar("Message", "Logout error",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
