import 'package:flutter/material.dart';
import 'package:icloset/db/closet_database.dart';
import 'package:icloset/pages/closet_items.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class OutfitsPage extends StatefulWidget {
  const OutfitsPage({super.key});

  @override
  State<OutfitsPage> createState() => _OutfitsPageState();
}

class _OutfitsPageState extends State<OutfitsPage> {
  List<Outfit> _outfits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOutfits();
  }

  Future<void> _loadOutfits() async {
    try {
      final outfits = await ClosetDatabase.instance.readAllOutfits();
      setState(() {
        _outfits = outfits;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar outfits: ${e.toString()}')),
      );
    }
  }

  void _toggleLike(int index) async {
    try {
      await ClosetDatabase.instance.toggleOutfitLike(_outfits[index].id);
      setState(() {
        _outfits[index] = _outfits[index].copyWith(
          isLiked: !_outfits[index].isLiked,
          likes: _outfits[index].isLiked 
              ? _outfits[index].likes - 1 
              : _outfits[index].likes + 1,
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar like: ${e.toString()}')),
      );
    }
  }

  Widget _buildItemRow(String label, ClosetItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(item.name)),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: FileImage(File(item.imagePath)),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Outfits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/create-outfit'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _outfits.isEmpty
              ? const Center(child: Text('No hay outfits guardados'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _outfits.length,
                  itemBuilder: (context, index) {
                    final outfit = _outfits[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              outfit.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Creado: ${DateFormat('dd/MM/yyyy').format(outfit.createdAt)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const Divider(height: 24),
                            _buildItemRow('Polera', outfit.top),
                            _buildItemRow('Pantalón', outfit.bottom),
                            _buildItemRow('Calzado', outfit.shoes),
                            if (outfit.accessories != null && outfit.accessories!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              const Text(
                                'Accesorios:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              ...outfit.accessories!.map((item) => 
                                _buildItemRow(item.category, item)
                              ).toList(),
                            ],
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        outfit.isLiked 
                                            ? Icons.favorite 
                                            : Icons.favorite_border,
                                        color: outfit.isLiked ? Colors.red : null,
                                      ),
                                      onPressed: () => _toggleLike(index),
                                    ),
                                    Text('${outfit.likes} likes'),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.share),
                                  onPressed: () {
                                    final accessoriesText = outfit.accessories != null && outfit.accessories!.isNotEmpty
                                        ? '\nAccesorios: ${outfit.accessories!.map((a) => a.name).join(', ')}'
                                        : '';
                                    
                                    Share.share(
                                      '¡Mira mi outfit en MyClosetApp!\n\n'
                                      '${outfit.name}\n'
                                      'Polera: ${outfit.top.name}\n'
                                      'Pantalón: ${outfit.bottom.name}\n'
                                      'Calzado: ${outfit.shoes.name}'
                                      '$accessoriesText\n\n'
                                      'Descarga la app: [Enlace al Play Store]',
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _confirmDelete(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> _confirmDelete(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Outfit'),
        content: const Text('¿Estás seguro de eliminar este outfit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ClosetDatabase.instance.deleteOutfit(_outfits[index].id);
        setState(() {
          _outfits.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Outfit eliminado')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: ${e.toString()}')),
        );
      }
    }
  }
}