import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    ));

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
            if (_isVCard(code)) {
              controller.stop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => QRCodeResultPage(qrCodeData: code),
                ),
              );
            } else {
              _navigateBackWithError(
                  context, 'Le QR Code détecté n\'est pas une vCard.');
            }
          } else {
            _navigateBackWithError(context, 'Code QR non valide.');
          }
        },
      ),
    );
  }

  /// Vérifie si le contenu correspond à une vCard
  bool _isVCard(String code) {
    return code.trim().startsWith('BEGIN:VCARD');
  }

  /// Navigue vers la page principale avec un message d'erreur
  void _navigateBackWithError(BuildContext context, String errorMessage) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MyHome(), // Retour à la page home
      ),
    );
    // Afficher un SnackBar avec le message d'erreur
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class QRCodeResultPage extends StatelessWidget {
  final String qrCodeData;

  const QRCodeResultPage({super.key, required this.qrCodeData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Résultat du QR Code')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'vCard détectée :',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              qrCodeData,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const MyHome(),
                  ),
                );
              },
              child: const Text('Scanner un autre QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
