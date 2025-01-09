import 'package:flutter/material.dart';
import 'database_service.dart';

class ListEntrePage extends StatefulWidget {
  const ListEntrePage({super.key});

  @override
  _ListEntrePageState createState() => _ListEntrePageState();
}

class _ListEntrePageState extends State<ListEntrePage> {
  late Future<List<Map<String, dynamic>>> entreList;
  List<Map<String, dynamic>> filteredEntreList = [];
  List<Map<String, dynamic>> originalEntreList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _searchController.addListener(_filterData);
  }

  Future<void> _fetchData() async {
    try {
      final data = await DatabaseService().fetchAllEntre();
      setState(() {
        originalEntreList = data;
        filteredEntreList = data;
      });
    } catch (e) {
      // Gérer les erreurs si nécessaire
    }
  }

  void _filterData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredEntreList = originalEntreList.where((entry) {
        final nom = entry['nom']?.toLowerCase() ?? '';
        final prenom = entry['prenom']?.toLowerCase() ?? '';
        return nom.contains(query) || prenom.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Liste des Entrées',
            style: TextStyle(
              color:Colors.white,
              fontWeight: FontWeight.bold
            ),

        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          // Barre de recherche améliorée
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher par nom',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.indigo, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.indigo, width: 2),
                ),
              ),
            ),
          ),
          // Liste des entrées avec des cartes
          Expanded(
            child: filteredEntreList.isEmpty
                ? const Center(child: Text('Aucune entrée trouvée.', style: TextStyle(fontSize: 18, color: Colors.grey)))
                : ListView.builder(
              itemCount: filteredEntreList.length,
              itemBuilder: (context, index) {
                final entree = filteredEntreList[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      'Député: ${entree['nom']} ${entree['prenom']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    subtitle: Text(
                      'Entrée le : ${entree['dateEntre']}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
