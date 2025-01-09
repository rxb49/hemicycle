import 'package:flutter/material.dart';
import 'liste_entre.dart';
import 'qr_scanner_page.dart';
// Ce code a été généré avec l'aide de l'intelligence artificielle.

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
                // Naviguer vers la page de scan
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
                    const ListEntrePage(),
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
