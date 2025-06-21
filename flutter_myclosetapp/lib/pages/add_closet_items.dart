import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../entity/closet_item.dart';
import '../db/closet_database.dart';

class AddClosetItemPage extends StatefulWidget {
  const AddClosetItemPage({super.key});

  @override
  State<AddClosetItemPage> createState() => _AddClosetItemPageState();
}

class _AddClosetItemPageState extends State<AddClosetItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedCategory;
  File? _imageFile;

  final List<String> _categories = ['Polera', 'Poleron', 'Pantalon', 'Accesorio'];

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 85);

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final name = basename(pickedFile.path);
      final savedImage = await File(pickedFile.path).copy('${directory.path}/$name');
      setState(() {
        _imageFile = savedImage;
      });
    }
  }

Future<void> _saveItem() async {
  final currentContext = context; // 👈 guarda el BuildContext antes de usar async

  if (_formKey.currentState!.validate() && _imageFile != null && _selectedCategory != null) {
    final newItem = ClosetItem(
      name: _nameController.text.trim(),
      imagePath: _imageFile!.path,
      category: _selectedCategory!,
    );

    await ClosetDatabase.instance.create(newItem);

    Navigator.pop(currentContext, true); // 👈 usamos el context seguro
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar prenda')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_imageFile != null)
                Image.file(_imageFile!, height: 250, fit: BoxFit.contain)
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Tomar Foto'),
                  onPressed: _takePicture,
                ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre de la prenda'),
                validator: (value) => value == null || value.isEmpty ? 'Ingresa un nombre' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: _categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator: (value) => value == null ? 'Selecciona una categoría' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Guardar'),
                onPressed: _saveItem,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
