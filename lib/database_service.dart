import 'package:mysql_client/mysql_client.dart';
// Ce code a été généré avec l'aide de l'intelligence artificielle.
class DatabaseService {
  // Connexion à la base de données
  Future<MySQLConnection> connectToDatabase() async {
    final conn = await MySQLConnection.createConnection(
      host: "192.168.10.16",
      port: 3306,
      userName: "tijou_robin",
      password: "VW3A9g7w",
      databaseName: "tijou_robin_hemicycle",
    );

    await conn.connect();
    return conn;
  }

  // Récupérer les données des députés en fonction du QR Code
  Future<Map<String, dynamic>?> fetchDeputesData(String qrCodeData) async {
    try {
      final conn = await connectToDatabase();

      // Extraire le nom et le prénom depuis le QR code
      String? nameLine = qrCodeData
          .split("\n")
          .firstWhere((line) => line.startsWith("N:"), orElse: () => "");

      if (nameLine.isNotEmpty) {
        nameLine = nameLine.replaceFirst("N:", "").trim();
        List<String> nameParts = nameLine.split(";");

        if (nameParts.length == 2) {
          String lastName = nameParts[0];
          String firstName = nameParts[1];

          // Recherche dans la base de données
          final result = await conn.execute(
            "SELECT * FROM deputes_active WHERE nom = :lastName AND prenom = :firstName LIMIT 1",
            {'lastName': lastName, 'firstName': firstName},
          );

          if (result.rows.isNotEmpty) {
            var row = result.rows.first;
            String? fullId = row.colByName('id');
            String numbersOnly = fullId?.replaceAll(RegExp(r'\D'), '') ?? '';

            // Construire les données à retourner
            return {
              'nom': row.colByName('nom'),
              'prenom': row.colByName('prenom'),
              'image':
              'https://datan.fr/assets/imgs/deputes_webp/depute_${numbersOnly}_webp.webp',
              'deputeId': numbersOnly,
            };
          }
        }
      }
      return null; // Retourne null si aucune donnée trouvée
    } catch (e) {
      throw Exception("Erreur lors de la récupération des données : $e");
    }
  }

  // Insérer dans la table `entreHemicycle`
  Future<void> insertIntoEntreHemicycle(String deputeId) async {
    try {
      final conn = await connectToDatabase();
      final currentDate = DateTime.now().toString();

      await conn.execute(
        "INSERT INTO `entreHemicycle` (`idEntre`, `idDepute`, `dateEntre`) VALUES (NULL, :deputeId, :dateEntre)",
        {'deputeId': deputeId, 'dateEntre': currentDate},
      );
    } catch (e) {
      throw Exception("Erreur lors de l'insertion : $e");
    }
  }
}
