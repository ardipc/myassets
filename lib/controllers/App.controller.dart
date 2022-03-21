import 'package:get/get.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/models/preferences.model.dart';

class AppController extends GetxController {
  DbHelper dbHelper = DbHelper();

  late List<Preferences> prefs = <Preferences>[];

  @override
  void onInit() {
    // TODO: implement onInit
    checkLogin();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void checkLogin() async {
    prefs = await dbHelper.initApp();
  }
}
