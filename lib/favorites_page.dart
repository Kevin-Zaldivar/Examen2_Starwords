import 'package:flutter/material.dart';
import 'favorites_service.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: FavoritesService.favoritesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final favorites = snapshot.data ?? [];

        if (favorites.isEmpty) {
          return const Center(
            child: Text(
              'No hay personajes favoritos',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (_, index) {
            final char = favorites[index];
            return Card(
              child: ListTile(
                title: Text(char['name']),
                subtitle: Text('Género: ${char['gender']}'),
              ),
            );
          },
        );
      },
    );
  }
}
