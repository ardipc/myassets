import 'package:get/get.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/models/preferences.model.dart';

class AppController extends GetxController {
  DbHelper dbHelper = DbHelper();

  late List<Preferences> prefs = <Preferences>[];

  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    checkLogin();
    super.onInit();
  }

  void checkLogin() async {
    prefs = await dbHelper.initApp();
  }
}
