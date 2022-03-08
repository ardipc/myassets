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
        title: Text('Barcode Scanner Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Scan'),
              onPressed: () async {
                try {
                  String barcode = await BarcodeScanner.scan();
                  setState(() {
                    this.barcode = barcode;
                  });
                } on PlatformException catch (error) {
                  if (error.code == BarcodeScanner.CameraAccessDenied) {
                    setState(() {
                      this.barcode =
                          'Izin kamera tidak diizinkan oleh si pengguna';
                    });
                  } else {
                    setState(() {
                      this.barcode = 'Error: $error';
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
