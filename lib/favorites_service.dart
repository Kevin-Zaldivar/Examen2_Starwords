import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesService {
  static final _db = FirebaseFirestore.instance;
  static final _collection = _db.collection('favoritos');

  /// Convierte la URL en un ID seguro para Firestore
  static String _sanitizeUrl(String url) {
    return url
        .replaceAll(RegExp(r'^https?://'), '') // quita https://
        .replaceAll('/', '_'); // reemplaza / por _
  }

  /// Agrega o elimina un personaje de favoritos
  static Future<void> toggleFavorite(Map<String, dynamic> character) async {
    final String url = character['url'];
    final String docId = _sanitizeUrl(url);
    final docRef = _collection.doc(docId);

    final snapshot = await docRef.get();
    if (snapshot.exists) {
      await docRef.delete(); // eliminar favorito
    } else {
      await docRef.set({
        'name': character['name'],
        'gender': character['gender'],
        'url': character['url'],
      });
    }
  }

  /// Verifica si el personaje ya es favorito
  static Future<bool> isFavorite(String url) async {
    final String docId = _sanitizeUrl(url);
    final doc = await _collection.doc(docId).get();
    return doc.exists;
  }

  /// Obtiene todos los favoritos una vez
  static Future<List<Map<String, dynamic>>> fetchFavorites() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Stream en tiempo real de los favoritos
  static Stream<List<Map<String, dynamic>>> favoritesStream() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}
