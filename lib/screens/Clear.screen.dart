import 'package:flutter/material.dart';

class ClearScreen extends StatefulWidget {
  const ClearScreen({Key? key}) : super(key: key);

  @override
  State<ClearScreen> createState() => _ClearScreen();
}

class _ClearScreen extends State<ClearScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clear Data'),
      ),
      body: Column(),
    );
  }
}
