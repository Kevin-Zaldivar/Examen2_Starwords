import 'package:flutter/material.dart';
import 'swapi_services.dart';
import 'favorites_service.dart';
import 'character_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> characters = [];
  List<Map<String, dynamic>> filteredCharacters = [];
  bool isLoading = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    setState(() => isLoading = true);
    final data = await SwapiService.fetchAllPeople();
    setState(() {
      characters = data;
      filteredCharacters = data;
      isLoading = false;
    });
  }

  void _searchCharacters(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        filteredCharacters = characters;
      });
    } else {
      final results = characters.where((char) {
        final name = char['name']?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase());
      }).toList();

      setState(() {
        filteredCharacters = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personajes de Star Wars'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (value) {
                _searchCharacters(value);
              },
              decoration: InputDecoration(
                hintText: 'Buscar personaje...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (characters.isEmpty)
              const Expanded(
                  child: Center(child: Text('No se encontraron personajes')))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCharacters.length,
                  itemBuilder: (_, index) {
                    final char = filteredCharacters[index];
                    return FutureBuilder<bool>(
                      future: FavoritesService.isFavorite(char['url']),
                      builder: (context, snapshot) {
                        final isFav = snapshot.data ?? false;
                        return Card(
                          child: ListTile(
                            title: Text(char['name'] ?? 'Sin nombre'),
                            subtitle: Text(
                                'Género: ${char['gender'] ?? 'desconocido'}'),
                            trailing: IconButton(
                              icon: Icon(
                                isFav ? Icons.star : Icons.star_border,
                                color: isFav ? Colors.yellow : null,
                              ),
                              onPressed: () async {
                                await FavoritesService.toggleFavorite(char);
                                setState(() {});
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CharacterDetailPage(character: char),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
