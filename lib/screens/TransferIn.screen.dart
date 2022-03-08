import 'package:flutter/material.dart';

class TransferInScreen extends StatefulWidget {
  const TransferInScreen({Key? key}) : super(key: key);

  @override
  State<TransferInScreen> createState() => _TransferInScreen();
}

class _TransferInScreen extends State<TransferInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer In'),
      ),
      body: Column(),
    );
  }
}
