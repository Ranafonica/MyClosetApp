import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:icloset/pages/closet_items.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener el ID del usuario actual
  String? _getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // ========== OPERACIONES CON PRENDAS ==========

  // Crear nueva prenda
  Future<ClosetItem> createClosetItem(ClosetItem item, File imageFile) async {
    final userId = _getCurrentUserId();
    if (userId == null) throw Exception('Usuario no autenticado');

    try {
      // Subir imagen a Firebase Storage
      final String imagePath = 'users/$userId/closet_items/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final UploadTask uploadTask = _storage.ref(imagePath).putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      // Crear documento en Firestore
      final docRef = _firestore.collection('closet_items').doc();
      
      // Crear el nuevo item con el ID de Firebase
      final newItem = ClosetItem(
        id: docRef.id, // Usar el ID generado por Firebase
        name: item.name,
        imagePath: downloadUrl,
        category: item.category,
        likes: item.likes,
        isLiked: item.isLiked,
      );

      await docRef.set({
        'id': docRef.id,
        'userId': userId,
        'name': newItem.name,
        'imagePath': newItem.imagePath,
        'category': newItem.category,
        'likes': newItem.likes,
        'isLiked': newItem.isLiked,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return newItem;
    } catch (e) {
      throw Exception('Error al crear prenda: $e');
    }
  }

  // Obtener todas las prendas del usuario
  Future<List<ClosetItem>> readAllItems() async {
    final userId = _getCurrentUserId();
    if (userId == null) throw Exception('Usuario no autenticado');

    try {
      final querySnapshot = await _firestore
          .collection('closet_items')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return ClosetItem(
          id: doc.id, // Usar el ID del documento de Firebase
          name: data['name'] ?? '',
          imagePath: data['imagePath'] ?? '',
          category: data['category'] ?? 'Otros',
          likes: (data['likes'] ?? 0).toInt(),
          isLiked: data['isLiked'] ?? false,
        );
      }).toList();
    } catch (e) {
      throw Exception('Error al cargar prendas: $e');
    }
  }

  // Eliminar prenda
  Future<void> deleteItem(String itemId) async {
    try {
      // Primero obtener la prenda para eliminar la imagen
      final doc = await _firestore.collection('closet_items').doc(itemId).get();
      final imagePath = doc.data()?['imagePath'] as String?;
      
      if (imagePath != null) {
        // Extraer path de storage desde la URL
        final ref = _storage.refFromURL(imagePath);
        await ref.delete();
      }

      // Eliminar documento de Firestore
      await _firestore.collection('closet_items').doc(itemId).delete();
    } catch (e) {
      throw Exception('Error al eliminar prenda: $e');
    }
  }

  // ========== OPERACIONES CON OUTFITS ==========

  // Crear nuevo outfit
  Future<Outfit> createOutfit(Outfit outfit) async {
    final userId = _getCurrentUserId();
    if (userId == null) throw Exception('Usuario no autenticado');

    try {
      final docRef = _firestore.collection('outfits').doc();
      
      final outfitData = {
        'id': docRef.id,
        'userId': userId,
        'name': outfit.name,
        'top_id': outfit.top.id,
        'bottom_id': outfit.bottom.id,
        'shoes_id': outfit.shoes.id,
        'likes': outfit.likes,
        'isLiked': outfit.isLiked,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await docRef.set(outfitData);

      // Guardar accesorios si existen
      if (outfit.accessories != null && outfit.accessories!.isNotEmpty) {
        final batch = _firestore.batch();
        for (final accessory in outfit.accessories!) {
          final accRef = _firestore
              .collection('outfits')
              .doc(docRef.id)
              .collection('accessories')
              .doc();
          
          batch.set(accRef, {
            'item_id': accessory.id,
          });
        }
        await batch.commit();
      }

      // Retornar el outfit con el nuevo ID
      return Outfit(
        id: docRef.id, // Usar el ID generado por Firebase
        name: outfit.name,
        top: outfit.top,
        bottom: outfit.bottom,
        shoes: outfit.shoes,
        accessories: outfit.accessories,
        createdAt: outfit.createdAt,
        likes: outfit.likes,
        isLiked: outfit.isLiked,
      );
    } catch (e) {
      throw Exception('Error al crear outfit: $e');
    }
  }

  // Obtener todos los outfits del usuario
  Future<List<Outfit>> readAllOutfits() async {
    final userId = _getCurrentUserId();
    if (userId == null) throw Exception('Usuario no autenticado');

    try {
      final outfitsSnapshot = await _firestore
          .collection('outfits')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      final allItems = await readAllItems();
      final outfits = <Outfit>[];

      for (final outfitDoc in outfitsSnapshot.docs) {
        final outfitData = outfitDoc.data();
        
        // Obtener accesorios del outfit
        final accessoriesSnapshot = await _firestore
            .collection('outfits')
            .doc(outfitDoc.id)
            .collection('accessories')
            .get();

        final accessoryIds = accessoriesSnapshot.docs
            .map((doc) => doc.data()['item_id'] as String)
            .toList();

        final accessories = allItems
            .where((item) => item.id != null && accessoryIds.contains(item.id))
            .toList();

        // Buscar las prendas principales - usar null-safe approach
        ClosetItem findItemById(String? itemId) {
          if (itemId == null) {
            return _createDefaultClosetItem();
          }
          return allItems.firstWhere(
            (item) => item.id == itemId,
            orElse: () => _createDefaultClosetItem(),
          );
        }

        final top = findItemById(outfitData['top_id'] as String?);
        final bottom = findItemById(outfitData['bottom_id'] as String?);
        final shoes = findItemById(outfitData['shoes_id'] as String?);

        final timestamp = outfitData['createdAt'] as Timestamp?;
        
        outfits.add(Outfit(
          id: outfitDoc.id, // Usar el ID del documento de Firebase
          name: outfitData['name'] ?? 'Outfit sin nombre',
          top: top,
          bottom: bottom,
          shoes: shoes,
          accessories: accessories.isNotEmpty ? accessories : null,
          likes: (outfitData['likes'] ?? 0).toInt(),
          isLiked: outfitData['isLiked'] ?? false,
          createdAt: timestamp?.toDate() ?? DateTime.now(),
        ));
      }

      return outfits;
    } catch (e) {
      throw Exception('Error al cargar outfits: $e');
    }
  }

  // Método auxiliar para crear un ClosetItem por defecto
  ClosetItem _createDefaultClosetItem() {
    return ClosetItem(
      id: 'default_item', // Usar un string constante en lugar de '0'
      name: 'No disponible',
      imagePath: '',
      category: 'Otros',
    );
  }

  // Eliminar outfit
  Future<void> deleteOutfit(String outfitId) async {
    try {
      // Eliminar accesorios primero
      final accessoriesSnapshot = await _firestore
          .collection('outfits')
          .doc(outfitId)
          .collection('accessories')
          .get();

      final batch = _firestore.batch();
      for (final doc in accessoriesSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // Eliminar el outfit
      await _firestore.collection('outfits').doc(outfitId).delete();
    } catch (e) {
      throw Exception('Error al eliminar outfit: $e');
    }
  }

  // Toggle like de outfit
  Future<void> toggleOutfitLike(String outfitId) async {
    try {
      final doc = await _firestore.collection('outfits').doc(outfitId).get();
      if (doc.exists) {
        final data = doc.data()!;
        final isLiked = data['isLiked'] ?? false;
        final likes = (data['likes'] ?? 0).toInt();

        await _firestore.collection('outfits').doc(outfitId).update({
          'isLiked': !isLiked,
          'likes': isLiked ? likes - 1 : likes + 1,
        });
      }
    } catch (e) {
      throw Exception('Error al actualizar like: $e');
    }
  }
}