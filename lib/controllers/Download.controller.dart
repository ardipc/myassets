import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadController extends GetxController {
  var isStart = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print("init download");
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    print("close download");
  }

  void confirmDownload() {
    Get.dialog(
      AlertDialog(
        title: Text("Confirmation"),
        content: Text("Are you sure to clear data ?"),
        actions: [
          TextButton(
            onPressed: () {
              // to do action in here
              startDownload();
              Get.back();
            },
            child: Text("YES"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("NO"),
          ),
        ],
      ),
    );
  }

  Future<void> startDownload() async {
    isStart.value = true;
    await Future.delayed(Duration(seconds: 10));
    isStart.value = false;
  }
}
