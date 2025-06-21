import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'; // Import añadido
import 'package:path/path.dart' as path; // Import modificado para evitar conflictos
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
  bool _isSaving = false;

  final List<String> _categories = ['Polera', 'Poleron', 'Pantalon', 'Accesorio'];

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final name = path.basename(pickedFile.path); // Usamos path.basename
      final savedImage = await File(pickedFile.path).copy('${directory.path}/$name');
      if (mounted) {
        setState(() {
          _imageFile = savedImage;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Por favor completa todos los campos');
      return;
    }

    if (_imageFile == null) {
      _showSnackBar('Debes tomar una foto de la prenda');
      return;
    }

    if (_selectedCategory == null) {
      _showSnackBar('Selecciona una categoría');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final newItem = ClosetItem(
        name: _nameController.text.trim(),
        imagePath: _imageFile!.path,
        category: _selectedCategory!,
      );

      await ClosetDatabase.instance.create(newItem);
      
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error al guardar: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
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
                decoration: const InputDecoration(
                  labelText: 'Nombre de la prenda',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty 
                    ? 'Ingresa un nombre' 
                    : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (value) {
                  if (mounted) {
                    setState(() => _selectedCategory = value);
                  }
                },
                validator: (value) => value == null 
                    ? 'Selecciona una categoría' 
                    : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveItem,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Guardar Prenda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}