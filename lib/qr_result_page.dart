import 'package:flutter/material.dart';
import 'database_service.dart';
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
      appBar: AppBar(
        title: const Text(
          'Résultat du QR Code',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: deputesData == null
            ? const CircularProgressIndicator()
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (image != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        image!,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.grey,
                          );
                        },
                      ),
                    )
                  else
                    const Icon(
                      Icons.person_off,
                      size: 100,
                      color: Colors.grey,
                    ),
                  const SizedBox(height: 20),
                  if (nom != null && prenom != null) ...[
                    Text(
                      'Nom : $nom',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Prénom : $prenom',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Date d\'entrée : $currentDate',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                    icon: const Icon(
                        Icons.home,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Retour à l\'accueil',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  }
