import 'package:flutter/material.dart';
import 'package:icloset/db/closet_database.dart';
import 'package:icloset/entity/closet_item.dart';
import 'add_closet_items.dart';

class MyClosetPage extends StatefulWidget {
  const MyClosetPage({super.key});

  @override
  State<MyClosetPage> createState() => _MyClosetPageState();
}

class _MyClosetPageState extends State<MyClosetPage> {
  List<ClosetItem> items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final loadedItems = await ClosetDatabase.instance.readAllItems();
    setState(() {
      items = loadedItems;
    });
  }

  Future<void> _confirmDelete(ClosetItem item) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Eliminar prenda'),
      content: Text('¿Estás seguro de eliminar "${item.name}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    await ClosetDatabase.instance.delete(item.id!);
    _loadItems(); // recargar la lista
  }
}

List<Widget> _buildGroupedItems() {
  final Map<String, List<ClosetItem>> groupedItems = {};

  for (var item in items) {
    groupedItems.putIfAbsent(item.category, () => []).add(item);
  }

  return groupedItems.entries.map((entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            entry.key,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...entry.value.map((item) => Card(
              child: ListTile(
                leading: Image.asset(item.imagePath, width: 50),
                title: Text(item.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(item),
                ),
              ),
            ))
      ],
    );
  }).toList();
}



  Future<void> _addItemDialog() async {
    String name = '';
    String imagePath = '';
    String category = '';
    

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar prenda'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Nombre'),
              onChanged: (value) => name = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Ruta imagen'),
              onChanged: (value) => imagePath = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Categoría'),
              onChanged: (value) => category = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Guardar'),
            onPressed: () async {
              if (name.isNotEmpty && imagePath.isNotEmpty) {
                final item = ClosetItem(name: name, imagePath: imagePath, category: category);
                await ClosetDatabase.instance.create(item);
                Navigator.pop(context);
                _loadItems(); // Recarga
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Closet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddClosetItemPage()),
              );

              if (result == true) {
                _loadItems(); // recargar la lista
              }
            },
          ),
        ],
      ),
      body: items.isEmpty
    ? const Center(child: Text('No hay prendas agregadas'))
    : ListView(
        children: _buildGroupedItems(),
      ),
    );
  }
}
