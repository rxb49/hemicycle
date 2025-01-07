import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QRScannerPage(),
    );
  }
}

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  bool isScanning = false;

  void showscan() {
    setState(() {
      isScanning = !isScanning; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner QR Code'),
        centerTitle: true,
      ),
      body: Center(
        child: isScanning
            ? MobileScanner(
                onDetect: (Barcode barcode, dynamic args) {
                  final String code = barcode.rawValue ?? "Inconnu";
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("QR Code détecté"),
                      content: Text(code),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Fermer"),
                        ),
                      ],
                    ),
                  );
                },
              )
            : const Text('Appuyez sur le bouton pour scanner un QR Code'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showscan,
        child: Icon(isScanning ? Icons.stop : Icons.camera_alt_rounded),
      ),
    );
  }
}
