import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myasset/screens/Clear.screen.dart';
import 'package:myasset/screens/Login.screen.dart';
import 'package:myasset/screens/Scan.screen.dart';
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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
              onPressed: () {
                print('click me');
                Get.to(
                  ClearScreen(),
                );
              },
              child: Text("Click Me"),
            ),
            TextButton(
              onPressed: () {
                Get.to(
                  LoginScreen(),
                );
              },
              child: Text("LOGIN"),
            ),
            TextButton(
              onPressed: () {
                Get.to(
                  ScanScreen(),
                );
              },
              child: Text("QRCODE"),
            ),
            TextButton(
              onPressed: () {
                Get.bottomSheet(MyDialog());
              },
              child: Text("Dialog"),
            ),
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

  Widget MyDialog() {
    return Container(
      child: Wrap(
        children: <Widget>[
          ListTile(
              leading: Icon(Icons.music_note),
              title: Text('Music'),
              onTap: () {}),
          ListTile(
            leading: Icon(Icons.videocam),
            title: Text('Video'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
