import 'dart:io';
import 'package:experience_app/feature/ecommerce/data/data_source/firebase_storage_data_source.dart';
import 'package:experience_app/feature/ecommerce/domain/entities/product.dart';
import 'package:experience_app/feature/ecommerce/presentation/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AdminProductFormView extends ConsumerStatefulWidget {
  final Product? product;

  const AdminProductFormView({super.key, this.product});

  bool get isEditing => product != null;

  @override
  ConsumerState<AdminProductFormView> createState() =>
      _AdminProductFormViewState();
}

class _AdminProductFormViewState extends ConsumerState<AdminProductFormView> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  late final nameController = TextEditingController(
    text: widget.product?.name ?? '',
  );
  late final descriptionController = TextEditingController(
    text: widget.product?.description ?? '',
  );
  late final priceController = TextEditingController(
    text: widget.product?.price.toString() ?? '',
  );
  late final sizesController = TextEditingController(
    text: widget.product?.sizes.join(', ') ?? '',
  );
  late final colorsController = TextEditingController(
    text: widget.product?.colorsHex.join(', ') ?? '',
  );

  File? pickedImageFile;
  String? currentImageUrl;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    currentImageUrl = widget.product?.imageUrl;
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        pickedImageFile = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          widget.isEditing ? 'Editar producto' : 'Nuevo producto',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FE),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE8E9F1)),
                    ),
                    child: pickedImageFile != null
                        ? Image.file(pickedImageFile!, fit: BoxFit.contain)
                        : (currentImageUrl != null &&
                              currentImageUrl!.isNotEmpty)
                        ? Image.network(
                            currentImageUrl!,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => _imagePlaceholder(),
                          )
                        : _imagePlaceholder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(
                    Icons.photo_library_outlined,
                    color: Color(0xFF006FFD),
                  ),
                  label: const Text(
                    'Elegir imagen',
                    style: TextStyle(color: Color(0xFF006FFD)),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: nameController,
                  decoration: _inputDecoration('Nombre'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: _inputDecoration('Descripción'),
                  maxLines: 3,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: priceController,
                  decoration: _inputDecoration('Precio (ej. 19.99)'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Requerido';
                    if (double.tryParse(v.trim()) == null)
                      return 'Número inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: sizesController,
                  decoration: _inputDecoration(
                    'Tallas separadas por coma (S, M, L)',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: colorsController,
                  decoration: _inputDecoration(
                    'Colores en hex separados por coma (#FF0000, #0000FF)',
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006FFD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: isSubmitting ? null : _submit,
                    child: isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            widget.isEditing
                                ? 'Guardar cambios'
                                : 'Crear producto',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return const Center(
      child: Icon(
        Icons.add_photo_alternate_outlined,
        size: 40,
        color: Color(0xFF8F9098),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isSubmitting = true);
    String imageUrl = currentImageUrl ?? '';
    if (pickedImageFile != null) {
      final storageDataSource = FirebaseStorageDataSource();
      imageUrl = await storageDataSource.uploadProductImage(pickedImageFile!);
      if (widget.isEditing &&
          currentImageUrl != null &&
          currentImageUrl!.isNotEmpty) {
        await storageDataSource.deleteProductImage(currentImageUrl!);
      }
    }

    final sizes = sizesController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final colors = colorsController.text
        .split(',')
        .map((c) => c.trim())
        .where((c) => c.isNotEmpty)
        .toList();

    final product = Product(
      id: widget.product?.id ?? '',
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      price: double.parse(priceController.text.trim()),
      sizes: sizes,
      colorsHex: colors,
      imageUrl: imageUrl,
    );

    try {
      final actions = ref.read(productActionsProvider);

      if (widget.isEditing) {
        await actions.editProduct(product);
      } else {
        await actions.addProduct(product);
      }

      if (!mounted) return;
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocurrió un error al guardar el producto'),
        ),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8F9FE),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFE8E9F1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF006FFD), width: 2),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    sizesController.dispose();
    colorsController.dispose();
    super.dispose();
  }
}
