import 'package:flutter/material.dart';

class TransferOutScreen extends StatefulWidget {
  const TransferOutScreen({Key? key}) : super(key: key);

  @override
  State<TransferOutScreen> createState() => _TransferOutScreen();
}

class _TransferOutScreen extends State<TransferOutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Out'),
      ),
      body: Column(),
    );
  }
}
