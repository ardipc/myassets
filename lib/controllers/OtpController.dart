import 'package:get/get.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/models/preferences.model.dart';
import 'package:sqflite/sqflite.dart';

class OtpController extends GetxController {
  DbHelper dbHelper = DbHelper();

  dynamic args = Get.arguments;
  RxString pin = "".obs;

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
    pin.value = v;
  }

  void actionSubmitOtp() async {
    Database db = await dbHelper.initDb();

    Preferences obj = Preferences(1, "true", args[0], args[1], "-", "-", 0, "-",
        "-", 0, "-", 0, 0, "-", 0, 0);

    // print(obj.toMap());

    int count = await db
        .update("preferences", obj.toMap(), where: "id = ?", whereArgs: [1]);

    // print(count);

    // List<Map<String, dynamic>> maps = await db.query("preferences");

    // print(maps);

    if (count == 1) {
      Get.offAllNamed('/home');
    } else {
      Get.snackbar(
        "OTP",
        pin.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
