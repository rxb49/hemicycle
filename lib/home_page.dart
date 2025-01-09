import 'package:flutter/material.dart';
import 'qr_scanner_page.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner QR Code')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) =>
                const BarcodeScannerWithController(),
              ),
            );
          },
          child: const Text('Ouvrir le scanner QR'),
        ),
      ),
    );
  }
}
