import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mysql_client/mysql_client.dart';

void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: MyHome(),
));

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  // Connexion à la base de données
  Future<MySQLConnection> connectToDatabase() async {
    final conn = await MySQLConnection.createConnection(
      host: "192.168.10.16", // Adresse IP de votre serveur ou localhost si local
      port: 3306,            // Numéro de port (souvent 3306 pour MySQL)
      userName: "tijou_robin",      // Nom d'utilisateur MySQL
      password: "VW3A9g7w",      // Mot de passe MySQL
      databaseName: "tijou_robin_hemicycle",  // Nom de la base de données
    );

    await conn.connect();
    print("Connexion établie avec succès !");
    return conn;
  }

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
        onDetect: (barcodeCapture) async {
          final barcode = barcodeCapture.barcodes.first;
          if (barcode.rawValue != null) {
            final String code = barcode.rawValue!;
            controller.stop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    QRCodeResultPage(qrCodeData: code), // Passe les données QR
              ),
            );
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

// Affichage des informations du QR Code et de la base de données
class QRCodeResultPage extends StatefulWidget {
  final String qrCodeData;

  const QRCodeResultPage({super.key, required this.qrCodeData});

  @override
  State<QRCodeResultPage> createState() => _QRCodeResultPageState();
}

class _QRCodeResultPageState extends State<QRCodeResultPage> {
  String? deputesData;

  @override
  void initState() {
    super.initState();
    _fetchDeputesData(); // Appeler la méthode pour récupérer les données
  }

  Future<void> _fetchDeputesData() async {
    try {
      final conn = await MySQLConnection.createConnection(
        host: "192.168.10.16",
        port: 3306,
        userName: "tijou_robin",
        password: "VW3A9g7w",
        databaseName: "tijou_robin_hemicycle",
      );

      await conn.connect();
      final result =
      await conn.execute("SELECT * FROM deputes_active LIMIT 1");

      if (result.rows.isNotEmpty) {
        setState(() {
          // Récupération des colonnes selon votre table
          deputesData =
          "Id : ${result.rows.first.colByName('id')}";
        });
      } else {
        setState(() {
          deputesData = "Aucune donnée trouvée dans la table.";
        });
      }

      await conn.close();
    } catch (e) {
      setState(() {
        deputesData = "Erreur : $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Résultat du QR Code')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'QR Code détecté :',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              widget.qrCodeData,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            if (deputesData == null)
              const CircularProgressIndicator()
            else
              Text(
                deputesData!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
