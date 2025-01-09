import 'package:flutter/material.dart';
import 'liste_entre.dart';
import 'qr_scanner_page.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner QR Code')),
      body: Center(
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
              child: const Text('Ouvrir le scanner QR'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la page ListEntrePage
                Navigator.of(context).push(
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) =>
                    const ListEntrePage(), // Utilisation de ListEntrePage importée
                  ),
                );
              },
              child: const Text('Liste des entrées'),
            ),
          ],
        ),
      ),
    );
  }
}
