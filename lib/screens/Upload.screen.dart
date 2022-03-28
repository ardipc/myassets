import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreen();
}

class _UploadScreen extends State<UploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload'),
      ),
      body: Center(
        child: Container(
          height: 50,
          width: Get.width * 0.4,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color.fromRGBO(44, 116, 180, 1),
            ),
            onPressed: () {},
            child: Text(
              "Start Upload",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
