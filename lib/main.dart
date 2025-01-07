import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // version ^3.0.0-beta.4

void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: MyHome(),
));

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Demo Home Page')),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) =>
                        const BarcodeScannerWithController(),
                  ),
                );
              },
              child: const Icon(Icons.camera_alt_rounded),
            ),
          ],
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
  BarcodeCapture? barcode;

  late final MobileScannerController controller;

  bool isStarted = true;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      torchEnabled: true,
      // formats: [BarcodeFormat.qrCode],
      // facing: CameraFacing.front,
      // detectionSpeed: DetectionSpeed.normal,
      // detectionTimeoutMs: 1000,
      // returnImage: false,
    );
    controller.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.hashCode.toString()),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              MobileScanner(
                controller: controller,
                errorBuilder: (
                  BuildContext context,
                  MobileScannerException error,
                  Widget? child,
                ) {
                  return ScannerErrorWidget(error: error);
                },
                fit: BoxFit.contain,
                onDetect: (BarcodeCapture barcode) {
                  setState(() {
                    this.barcode = barcode;
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
        break;
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
        break;
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
