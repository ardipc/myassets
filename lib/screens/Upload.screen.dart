import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myasset/controllers/Upload.controller.dart';

class UploadScreen extends StatelessWidget {
  final uploadController = Get.put(UploadController());

  UploadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload'),
        actions: [
          if (uploadController.isStart.value) ...[
            IconButton(
              onPressed: () {
                uploadController.restart();
              },
              icon: const Icon(Icons.refresh),
            )
          ]
        ],
      ),
      body: Obx(
        () => uploadController.isStart.value
            ? uploadController.isLoading.value
                ? const Center(
                    child: CupertinoActivityIndicator(),
                  )
                : Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(12),
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1),
                    ),
                    color: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.all(6.0),
                      child: ListView(
                        children: uploadController.listProgress,
                      ),
                    ),
                  )
            : Center(
                child: SizedBox(
                  height: 50,
                  width: Get.width * 0.4,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(44, 116, 180, 1),
                    ),
                    onPressed: () {
                      uploadController.confirmDownload();
                    },
                    child: const Text(
                      "Start Upload",
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
