import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageWidget {
  Future<dynamic> titleAndMessage(var title, var content) {
    return Get.dialog(
      AlertDialog(
        title: title,
        content: content,
      ),
    );
  }
}
