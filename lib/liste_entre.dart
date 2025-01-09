import 'package:flutter/material.dart';
import 'database_service.dart';
// Ce code a été généré avec l'aide de l'intelligence artificielle.

class ListEntrePage extends StatefulWidget {
  const ListEntrePage({super.key});

  @override
  _ListEntrePageState createState() => _ListEntrePageState();
}

class _ListEntrePageState extends State<ListEntrePage> {
  late Future<List<Map<String, dynamic>>> entreList;

  @override
  void initState() {
    super.initState();
    entreList = DatabaseService().fetchAllEntre();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des Entrées')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: entreList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune entrée trouvée.'));
          } else {
            final entrees = snapshot.data!;
            return ListView.builder(
              itemCount: entrees.length,
              itemBuilder: (context, index) {
                final entree = entrees[index];
                return ListTile(
                  title: Text('Député: ${entree['nom']} ${entree['prenom']}'),
                  subtitle: Text('Entrée le : ${entree['dateEntre']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
