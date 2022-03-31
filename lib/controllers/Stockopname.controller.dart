import 'package:get/get.dart';

class StockOpnameController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    print(Get.arguments);
    print('onInit');
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    print('onClose');
    super.onClose();
  }
}
