import 'dart:io';
import 'package:flutter/material.dart';
import 'package:icloset/db/closet_database.dart';
import 'package:icloset/pages/closet_items.dart';

class CreateOutfitPage extends StatefulWidget {
  const CreateOutfitPage({super.key});

  @override
  State<CreateOutfitPage> createState() => _CreateOutfitPageState();
}

class _CreateOutfitPageState extends State<CreateOutfitPage> {
  final Map<String, ClosetItem?> _selectedItems = {
    'Polera': null,
    'Pantalon': null,
    'Calzado': null,
    'Poleron': null,
    'Accesorio': null,
    'Chaqueta': null,
    'Camisa': null,
  };

  List<ClosetItem> _availableItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClosetItems();
  }

  Future<void> _loadClosetItems() async {
    try {
      final items = await ClosetDatabase.instance.readAllItems();
      setState(() {
        _availableItems = items.whereType<ClosetItem>().toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar prendas: ${e.toString()}')),
      );
    }
  }

  void _selectItem(String category, ClosetItem item) {
    setState(() {
      _selectedItems[category] = item;
    });
  }

  void _saveOutfit() {
    if (_selectedItems['Polera'] == null ||
        _selectedItems['Pantalon'] == null ||
        _selectedItems['Calzado'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes seleccionar al menos Polera, Pantalón y Calzado'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final newOutfit = Outfit(
      id: DateTime.now().millisecondsSinceEpoch,
      name: 'Outfit ${DateTime.now().toString()}',
      top: _selectedItems['Polera']!,
      bottom: _selectedItems['Pantalon']!,
      shoes: _selectedItems['Calzado']!,
      accessories: [
        if (_selectedItems['Poleron'] != null) _selectedItems['Poleron']!,
        if (_selectedItems['Accesorio'] != null) _selectedItems['Accesorio']!,
        if (_selectedItems['Chaqueta'] != null) _selectedItems['Chaqueta']!,
        if (_selectedItems['Camisa'] != null) _selectedItems['Camisa']!,
      ],
      createdAt: DateTime.now(),
    );

    Navigator.pop(context, newOutfit);
  }

  Widget _buildCategorySelector(String category) {
    final categoryItems = _availableItems
        .where((item) => item.category == category)
        .toList();

    return ExpansionTile(
      title: Text(
        category,
        style: TextStyle(
          fontWeight: _selectedItems[category] != null ? FontWeight.bold : null,
          color: _selectedItems[category] != null ? Colors.blue : null,
        ),
      ),
      subtitle: _selectedItems[category] != null
          ? Text(_selectedItems[category]!.name)
          : null,
      children: [
        if (categoryItems.isEmpty)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('No tienes prendas de esta categoría'),
          )
        else
          ...categoryItems.map((item) => ListTile(
                leading: Image.file(File(item.imagePath), width: 50, height: 50),
                title: Text(item.name),
                onTap: () => _selectItem(category, item),
                trailing: _selectedItems[category]?.id == item.id
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
              )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Outfit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveOutfit,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Elementos esenciales',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildCategorySelector('Polera'),
                  _buildCategorySelector('Pantalon'),
                  _buildCategorySelector('Calzado'),
                  const Divider(height: 32),
                  const Text(
                    'Elementos opcionales',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildCategorySelector('Poleron'),
                  _buildCategorySelector('Accesorio'),
                  _buildCategorySelector('Chaqueta'),
                  _buildCategorySelector('Camisa'),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _saveOutfit,
                    child: const Text('Guardar Outfit'),
                  ),
                ],
              ),
            ),
    );
  }
}