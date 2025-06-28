import 'package:flutter/material.dart';

class CharacterDetailPage extends StatelessWidget {
  final Map<String, dynamic> character;

  const CharacterDetailPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character['name'] ?? 'Detalle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🪪 Nombre: ${character['name'] ?? 'Desconocido'}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text('🧬 Género: ${character['gender'] ?? 'Desconocido'}'),
            Text('📏 Altura: ${character['height'] ?? '¿?'} cm'),
            Text('⚖️ Peso: ${character['mass'] ?? '¿?'} kg'),
            Text('👁️ Color de ojos: ${character['eye_color'] ?? '¿?'}'),
            Text('🌍 Planeta origen: ${character['homeworld'] ?? '¿?'}'),
            const SizedBox(height: 20),
            const Text(
              '🎬 Películas:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ..._buildFilmList(character['films']),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFilmList(dynamic films) {
    if (films is List && films.isNotEmpty) {
      return films
          .map<Widget>(
              (filmUrl) => Text('• ${filmUrl.toString().split('/').last}'))
          .toList();
    }
    return [const Text('No hay películas registradas')];
  }
}
