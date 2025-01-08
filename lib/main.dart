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
  String? image;

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

      // Extraction du nom et prénom depuis le QR code
      String qrCode = widget.qrCodeData;

      // Chercher la ligne contenant "N:" et extraire nom et prénom
      String? nameLine = qrCode.split("\n").firstWhere((line) => line.startsWith("N:"), orElse: () => "");

      if (nameLine.isNotEmpty) {
        // Supprimer "N:" et séparer le nom et prénom par ";"
        nameLine = nameLine.replaceFirst("N:", "").trim();
        List<String> nameParts = nameLine.split(";");

        if (nameParts.length == 2) {
          String lastName = nameParts[0];  // "Bazin"
          String firstName = nameParts[1]; // "Thibault"

          // Recherche dans la base de données par nom et prénom
          final result = await conn.execute(
              "SELECT * FROM deputes_active WHERE nom = :lastName AND prenom = :firstName LIMIT 1",
              {
                'lastName': lastName, // Paramètre pour le nom
                'firstName': firstName, // Paramètre pour le prénom
              }
          );

          if (result.rows.isNotEmpty) {
            setState(() {
              // Récupération des données de la ligne correspondante
              var row = result.rows.first;
              deputesData = "Nom : ${row.colByName('nom')}, Prénom : ${row.colByName('prenom')}";

              // Extrait l'ID pour construire l'URL de l'image
              String? fullId = row.colByName('id'); // Exemple : "PA1078"
              String numbersOnly = ''; // Déclare 'numbersOnly' ici
              if (fullId != null) {
                numbersOnly = fullId.replaceAll(RegExp(r'\D'), ''); // Supprime tout sauf les chiffres
              }

              // Construction de l'URL de l'image
              image = 'https://datan.fr/assets/imgs/deputes_webp/depute_${numbersOnly}_webp.webp';

              // Vérification de l'existence et de la validité de l'image
              if (image != null && image!.isNotEmpty) {
                // Effectuer l'insertion dans une fonction asynchrone distincte
                _insertIntoEntreHemicycle(numbersOnly, conn);
              }
            });
          } else {
            setState(() {
              deputesData = "Aucun député trouvé pour ce nom et prénom.";
            });
          }
        } else {
          setState(() {
            deputesData = "Nom et prénom mal formatés dans le QR Code.";
          });
        }
      } else {
        setState(() {
          deputesData = "Aucune information de nom et prénom trouvée dans le QR Code.";
        });
      }

      await conn.close();
    } catch (e) {
      setState(() {
        deputesData = "Erreur : $e";
      });
    }
  }

// Nouvelle fonction asynchrone pour l'insertion
  Future<void> _insertIntoEntreHemicycle(String deputeId, MySQLConnection conn) async {
    try {
      String currentDate = DateTime.now().toString(); // Date actuelle
      await conn.execute(
          "INSERT INTO `entreHemicycle` (`idEntre`, `idDepute`, `dateEntre`) VALUES (NULL, :deputeId, :dateEntre)",
          {
            'deputeId': deputeId, // Utilisation de numbersOnly pour l'ID du député
            'dateEntre': currentDate, // La date de scan
          }
      );
      setState(() {
        deputesData = "Entrée enregistrée avec succès à $currentDate";
      });
    } catch (e) {
      setState(() {
        deputesData = "Erreur lors de l'insertion dans entreHemicycle : $e";
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

            // Vérification de nullité pour 'image'
            if (image == null || image!.isEmpty) ...[
              const CircularProgressIndicator(),
            ] else ...[
              Image.network(
                image!, // URL de l'image dynamique
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                },
              ),
            ],
            if (deputesData != null) ...[
              const SizedBox(height: 20),
              Text(
                deputesData!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
