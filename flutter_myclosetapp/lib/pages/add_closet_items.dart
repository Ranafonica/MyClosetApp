import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:icloset/pages/closet_items.dart'; // Cambiado a pages
import 'package:icloset/db/closet_database.dart';
import 'package:icloset/firebase_service.dart';
import 'dart:io';

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

  final List<String> _categories = ['Polera', 'Poleron', 'Pantalon', 'Accesorio', 'Calzado', 'Chaqueta', 'Camisa', 'Vestido', 'Short'];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final fileName = path.basename(pickedFile.path);
        final savedImage = await File(pickedFile.path).copy('${directory.path}/$fileName');
        
        if (mounted) {
          setState(() {
            _imageFile = savedImage;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error: ${e.toString()}');
      }
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar imagen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tomar foto'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Elegir de galería'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
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
    _showSnackBar('Debes seleccionar una imagen');
    return;
  }

  if (_selectedCategory == null) {
    _showSnackBar('Selecciona una categoría');
    return;
  }

  setState(() => _isSaving = true);

  try {
    final newItem = ClosetItem(
      id: '', // Dejar vacío, Firebase generará el ID
      name: _nameController.text.trim(),
      imagePath: '', // Temporal, se actualizará después de subir la imagen
      category: _selectedCategory!,
    );

    await FirebaseService().createClosetItem(newItem, _imageFile!);
    
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
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar prenda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveItem,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Sección de imagen
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_imageFile!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Toca para agregar imagen'),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Campo de nombre
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la prenda',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label),
                ),
                validator: (value) => value == null || value.isEmpty 
                    ? 'Ingresa un nombre' 
                    : null,
              ),
              const SizedBox(height: 20),

              // Selector de categoría
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
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

              // Botón de guardar
              ElevatedButton(
                onPressed: _isSaving ? null : _saveItem,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator()
                    : const Text('GUARDAR PRENDA', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}