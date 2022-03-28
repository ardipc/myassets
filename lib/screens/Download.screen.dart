import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreen();
}

class _DownloadScreen extends State<DownloadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download'),
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
              "Start Download",
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
