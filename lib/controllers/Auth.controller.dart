import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/cache.helper.dart';

class AuthController extends GetxController with CacheManager {
  final isLogged = false.obs;

  void actionLogOut() {
    isLogged.value = false;
  }

  void actionLogin() {
    isLogged.value = true;
  }

  void checkLogin() async {
    final token = getToken();
    if (token != null) {
      isLogged.value = true;
    }
  }

  void actionLogout() async {
    final box = GetStorage();
    box.remove('userId');
    box.remove('username');
    box.remove('roleId');
    box.remove('roleName');
    box.remove('realName');
    Get.offAllNamed('/login');
  }
}
