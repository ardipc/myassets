// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myasset/screens/Clear.screen.dart';
import 'package:myasset/screens/Download.screen.dart';
import 'package:myasset/screens/Login.screen.dart';
import 'package:myasset/screens/Scan.screen.dart';
import 'package:myasset/screens/Settings.screen.dart';
import 'package:myasset/screens/StockOpname.screen.dart';
import 'package:myasset/screens/TransferIn.screen.dart';
import 'package:myasset/screens/TransferOut.screen.dart';
import 'package:myasset/screens/Upload.screen.dart';
import 'package:myasset/widgets/NavDrawer.widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: NavDrawerWidget(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Container(
                  margin: new EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  height: 80,
                  width: 200,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 96, 141, 184),
                    ),
                    onPressed: () {
                      Get.to(
                        StockOpnameScreen(),
                      );
                    },
                    child: Text(
                      "Stock Opname",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  width: 200,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 28, 195, 218),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Dispose",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Container(
                  margin: new EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  height: 80,
                  width: 200,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 57, 104, 190),
                    ),
                    onPressed: () {
                      Get.to(TransferInScreen());
                    },
                    child: Text(
                      "Transfer In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  width: 200,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 23, 95, 204),
                    ),
                    onPressed: () {
                      Get.to(TransferOutScreen());
                    },
                    child: Text(
                      "Transer Out",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Container(
                  margin: new EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  height: 80,
                  width: 200,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 86, 69, 170),
                    ),
                    onPressed: () {
                      Get.to(DownloadScreen());
                    },
                    child: Text(
                      "Download Data",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  width: 200,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 108, 5, 177),
                    ),
                    onPressed: () {
                      Get.to(UploadScreen());
                    },
                    child: Text(
                      "Upload Data",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Container(
                  margin: new EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  height: 80,
                  width: 200,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 190, 126, 6),
                    ),
                    onPressed: () {
                      Get.to(ClearScreen());
                    },
                    child: Text(
                      "Clear Data",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  width: 200,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 223, 135, 20),
                    ),
                    onPressed: () {
                      Get.to(SettingsScreen());
                    },
                    child: Text(
                      "Setting",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Container(
                  margin: new EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  height: 80,
                  width: 405,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 252, 0, 0),
                    ),
                    onPressed: () {
                      Get.to(LoginScreen());
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            )

            // const Text(
            //   'You have pushed the button this many times:',
            // ),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headline4,
            // ),
            // TextButton(
            //   onPressed: () {
            //     print('click me');
            //     Get.to(
            //       ClearScreen(),
            //     );
            //   },
            //   child: Text("Click Me"),
            // ),
            // TextButton(
            //   onPressed: () {
            //     Get.to(
            //       LoginScreen(),
            //     );
            //   },
            //   child: Text("LOGIN"),
            // ),
            // TextButton(
            //   onPressed: () {
            //     Get.to(
            //       ScanScreen(),
            //     );
            //   },
            //   child: Text("QRCODE"),
            // ),
            // TextButton(
            //   onPressed: () {
            //     Get.bottomSheet(MyDialog());
            //   },
            //   child: Text("Dialog"),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Widget MyDialog() {
  //   return Container(
  //     child: Wrap(
  //       children: <Widget>[
  //         ListTile(
  //             leading: Icon(Icons.music_note),
  //             title: Text('Music'),
  //             onTap: () {}),
  //         ListTile(
  //           leading: Icon(Icons.videocam),
  //           title: Text('Video'),
  //           onTap: () {},
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
