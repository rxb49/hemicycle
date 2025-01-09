import 'package:flutter/material.dart';
import 'database_service.dart';
// Ce code a été généré avec l'aide de l'intelligence artificielle.
class QRCodeResultPage extends StatefulWidget {
  final String qrCodeData;

  const QRCodeResultPage({super.key, required this.qrCodeData});

  @override
  State<QRCodeResultPage> createState() => _QRCodeResultPageState();
}

class _QRCodeResultPageState extends State<QRCodeResultPage> {
  final DatabaseService dbService = DatabaseService();
  String? deputesData;
  String? image;
  String? nom;
  String? prenom;
  String? currentDate;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await dbService.fetchDeputesData(widget.qrCodeData);

      if (data != null) {
        setState(() {
          deputesData = "Nom : ${data['nom']}, Prénom : ${data['prenom']}";
          nom = data['nom'];
          prenom = data['prenom'];
          image = data['image'];
          currentDate = DateTime.now().toString();
        });

        // Insérer dans la base
        await dbService.insertIntoEntreHemicycle(data['deputeId']);
      } else {
        // Afficher le message avant de rediriger
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Code QR non valide.'),
            duration: Duration(seconds: 2),
          ),
        );

        // Attendre un court instant pour s'assurer que le SnackBar s'affiche
        await Future.delayed(const Duration(seconds: 2));

        // Rediriger l'utilisateur vers la page d'accueil
        Navigator.of(context).pushReplacementNamed('/');
      }
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
        child: deputesData == null
            ? const CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null)
              Image.network(image!)
            else
              const Text('Image non disponible'),
            if (nom != null && prenom != null) ...[
              const SizedBox(height: 20),
              Text(
                'Nom: $nom',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Prénom: $prenom',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Date d\'entrée: $currentDate',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
