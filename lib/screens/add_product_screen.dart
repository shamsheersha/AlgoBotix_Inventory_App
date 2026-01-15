import 'dart:io';

import 'package:algobotix_inventory_app/models/product/product_model.dart';
import 'package:algobotix_inventory_app/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddProductScreen extends StatefulWidget {
  final ProductModel? product;
  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productIdController = .new();
  final TextEditingController _nameController = .new();
  final TextEditingController _descriptionController = .new();
  final TextEditingController _stockController = .new();
  String? _imagePath;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _isEditing = true;
      _productIdController.text = widget.product!.productId;
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _stockController.text = widget.product!.currentStock.toString();
      _imagePath = widget.product!.imagePath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'Add Product'),
        actions: _isEditing
            ? [
                IconButton(
                  icon: const Icon(Icons.qr_code),
                  onPressed: _showQRCode,
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const .all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 24),
              _buildProductIdField(),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _nameController,
                label: 'Product Name',
                icon: Icons.label_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.description_outlined,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _stockController,
                label: 'Initial Stock',
                icon: Icons.inventory_outlined,
                keyboardType: TextInputType.number,
                enabled: !_isEditing,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter stock quantity';
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 0) {
                    return 'Please enter valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const .symmetric(vertical: 16),
                ),
                child: Text(
                  _isEditing ? 'Update Product' : 'Add Product',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: .w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: .circular(16),
          border: .all(color: Colors.grey[300]!),
        ),
        child: _imagePath != null && File(_imagePath!).existsSync()
            ? ClipRRect(
                borderRadius: .circular(16),
                child: Image.file(File(_imagePath!), fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: .center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to add product image',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildProductIdField() {
    return TextFormField(
      controller: _productIdController,
      decoration: InputDecoration(
        labelText: "Product ID",
        hintText: 'Enter 5 aplhanumeric characters',
        prefixIcon: const Icon(Icons.qr_code_2),
        helperText: 'Must be exactly 5 characters (A-Z, 0-9)',
      ),
      textCapitalization: .characters,
      enabled: !_isEditing,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
        LengthLimitingTextInputFormatter(5),
        UpperCaseTextFormatter(),
      ],
      validator: (value) {
        if (value == null || value.length != 5) {
          return 'Product ID must be exactly 5 characters';
        }
        if (!RegExp(r'^[A-Z0-9]+$').hasMatch(value)) {
          return 'Only alphanumeric characters allowed';
        }
        if (!_isEditing) {
          final provider = context.read<ProductProvider>();
          if (!provider.isProductIdUnique(value)) {
            return 'Product ID already exists';
          }
        }
        return null;
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      enabled: enabled,
      validator: validator,
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: .vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const .all(24),
        child: Column(
          mainAxisSize: .min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, maxWidth: 1024);
    
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<ProductProvider>();

    if (_isEditing) {
      widget.product!.name = _nameController.text.trim();
      widget.product!.description = _descriptionController.text.trim();
      widget.product!.imagePath = _imagePath;
      
      await provider.updateProduct(widget.product!);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully')),
        );
        Navigator.pop(context);
      }
    } else {
      final product = ProductModel(
        productId: _productIdController.text.trim(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        currentStock: int.parse(_stockController.text.trim()),
        imagePath: _imagePath,
        timeStamp: DateTime.now(),
      );

      final success = await provider.addProduct(product);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added successfully')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product ID already exists')),
          );
        }
      }
    }
}
  void _showQRCode() {
    if (widget.product == null) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: .circular(20)),
        child: Padding(
          padding: const .all(24),
          child: Column(
            mainAxisSize: .min,
            children: [
              Text(
                'Product QR Code',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const .all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: .circular(12),
                  border: .all(color: Colors.grey[300]!),
                ),
                child: QrImageView(
                  data: widget.product!.productId,
                  version: QrVersions.auto,
                  size: 200,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.product!.productId,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: .bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}