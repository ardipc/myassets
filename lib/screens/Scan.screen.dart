// ignore_for_file: deprecated_member_use

// ignore: import_of_legacy_library_into_null_safe
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreen();
}

class _ScanScreen extends State<ScanScreen> {
  String barcode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: const Text('Scan'),
              onPressed: () async {
                try {
                  String barcode = await BarcodeScanner.scan();
                  setState(() {
                    this.barcode = barcode;
                  });
                } on PlatformException catch (error) {
                  if (error.code == BarcodeScanner.CameraAccessDenied) {
                    setState(() {
                      barcode = 'Izin kamera tidak diizinkan oleh si pengguna';
                    });
                  } else {
                    setState(() {
                      barcode = 'Error: $error';
                    });
                  }
                }
              },
            ),
            Text(
              'Result: $barcode',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
