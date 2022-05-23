import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myasset/controllers/Download.controller.dart';

class DownloadScreen extends StatelessWidget {
  DownloadScreen({Key? key}) : super(key: key);

  final downloadController = Get.put(DownloadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download'),
        actions: [
          if (downloadController.isStart.value) ...[
            IconButton(
              onPressed: () {
                downloadController.restart();
              },
              icon: Icon(Icons.refresh),
            )
          ]
        ],
      ),
      body: Obx(
        () => downloadController.isStart.value
            ? Card(
                elevation: 4,
                margin: const EdgeInsets.all(12),
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(6.0),
                  child: ListView(
                    children: downloadController.listProgress,
                  ),
                ),
              )
            : Center(
                child: Container(
                  height: 50,
                  width: Get.width * 0.4,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromRGBO(44, 116, 180, 1),
                    ),
                    onPressed: () {
                      downloadController.confirmDownload();
                    },
                    child: const Text(
                      "Start Download",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
