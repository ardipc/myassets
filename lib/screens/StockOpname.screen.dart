import 'package:flutter/material.dart';

class StockOpnameScreen extends StatefulWidget {
  StockOpnameScreen({Key? key}) : super(key: key);

  @override
  State<StockOpnameScreen> createState() => _StockOpnameScreenState();
}

class _StockOpnameScreenState extends State<StockOpnameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Opname'),
      ),
      body: Column(),
    );
  }
}
