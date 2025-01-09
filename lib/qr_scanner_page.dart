import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'qr_result_page.dart';
// Ce code a été généré avec l'aide de l'intelligence artificielle.
class BarcodeScannerWithController extends StatefulWidget {
  const BarcodeScannerWithController({super.key});

  @override
  _BarcodeScannerWithControllerState createState() =>
      _BarcodeScannerWithControllerState();
}

class _BarcodeScannerWithControllerState
    extends State<BarcodeScannerWithController> {
  late final MobileScannerController controller;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(torchEnabled: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner QR Code'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () {
              controller.toggleTorch();
            },
          ),
        ],
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (barcodeCapture) {
          final barcode = barcodeCapture.barcodes.first;
          if (barcode.rawValue != null) {
            final String code = barcode.rawValue!;
            controller.stop();

            if (_isValidVCard(code)) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QRCodeResultPage(qrCodeData: code),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('QR Code non valide ou non au format vCard.'),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.of(context).pop();
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Code QR non valide.'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }

  bool _isValidVCard(String code) {
    return code.contains('BEGIN:VCARD') && code.contains('END:VCARD');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
