import 'package:flutter/material.dart';
import 'liste_entre.dart';
import 'qr_scanner_page.dart';

// Ce code a été généré avec l'aide de l'intelligence artificielle.

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          'Accueil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ) ,
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Bienvenue dans l\'application QR Scanner de l\'assemblé nationale',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),

            ElevatedButton.icon(
              onPressed: () {
                // Naviguer vers la page de scan
                Navigator.of(context).push(
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) =>
                    const BarcodeScannerWithController(),
                  ),
                );
              },
              icon: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
              ),
              label: const Text(
                  'Ouvrir le scanner QR',
                  style: TextStyle(
                    color: Colors.white
                  ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                minimumSize: const Size(200, 60),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                // Naviguer vers la page ListEntrePage
                Navigator.of(context).push(
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => const ListEntrePage(),
                  ),
                );
              },
              icon: const Icon(
                  Icons.list,
                  color: Colors.white,
              ),
              label: const Text(
                  'Liste des entrées',
                  style: TextStyle(
                    color: Colors.white,
                  ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                minimumSize: const Size(200, 60),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),

          ],
        ),
      ),
    );
  }
}
