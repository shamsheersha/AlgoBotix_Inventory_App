import 'dart:io';

import 'package:algobotix_inventory_app/models/product/product_model.dart';
import 'package:algobotix_inventory_app/providers/product_provider.dart';
import 'package:algobotix_inventory_app/screens/add_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _stockController = TextEditingController();

  @override
  void dispose() {
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProductInfo(),
                _buildStockControl(),
                _buildStockHistory(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: widget.product.imagePath != null &&
                File(widget.product.imagePath!).existsSync()
            ? Image.file(
                File(widget.product.imagePath!),
                fit: .cover,
              )
            : Container(
                color: Colors.grey[300],
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 100,
                  color: Colors.grey[400],
                ),
              ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _editProduct(),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _deleteProduct(),
        ),
      ],
    );
  }

  Widget _buildProductInfo() {
    return Card(
      margin: const .all(24),
      child: Padding(
        padding: const .all(20),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                Container(
                  padding: const .symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.1),
                    borderRadius: .circular(8),
                  ),
                  child: Text(
                    widget.product.productId,
                    style: const TextStyle(
                      color: Color(0xFF6366F1),
                      fontWeight: .bold,
                      fontSize: 14,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.product.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: .bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.description,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const Divider(height: 32),
            _buildInfoRow(
              Icons.inventory_outlined,
              'Current Stock',
              '${widget.product.currentStock} units',
              _getStockColor(widget.product.currentStock),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.access_time,
              'Added On',
              DateFormat('MMM dd, yyyy • hh:mm a').format(widget.product.timeStamp),
              Colors.grey[600]!,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.person_outline,
              'Added By',
              widget.product.addedBy,
              Colors.grey[600]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[400]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: .w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStockControl() {
    return Card(
      margin: const .symmetric(horizontal: 24),
      child: Padding(
        padding: const .all(20),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            const Text(
              'Stock Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: .bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStockButton(
                    icon: Icons.remove,
                    label: 'Remove',
                    color: Colors.red,
                    onPressed: () => _showStockDialog(false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStockButton(
                    icon: Icons.add,
                    label: 'Add',
                    color: Colors.green,
                    onPressed: () => _showStockDialog(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const .symmetric(vertical: 16),
      ),
      child: Row(
        mainAxisAlignment: .center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildStockHistory() {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        final history = provider.getProductHistory(widget.product.productId);

        if (history.isEmpty) {
          return const SizedBox.shrink();
        }

        return Card(
          margin: const .all(24),
          child: Padding(
            padding: const .all(20),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                const Text(
                  'Stock History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: .bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: history.length,
                  separatorBuilder: (_, __) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final item = history[index];
                    final isPositive = item.changeAmount > 0;

                    return Row(
                      children: [
                        Container(
                          padding: const .all(8),
                          decoration: BoxDecoration(
                            color: (isPositive ? Colors.green : Colors.red)
                                .withOpacity(0.1),
                            borderRadius: .circular(8),
                          ),
                          child: Icon(
                            isPositive ? Icons.add : Icons.remove,
                            color: isPositive ? Colors.green : Colors.red,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                item.reason,
                                style: const TextStyle(
                                  fontWeight: .w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('MMM dd, yyyy • hh:mm a')
                                    .format(item.timestamp),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: .end,
                          children: [
                            Text(
                              '${isPositive ? '+' : ''}${item.changeAmount}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isPositive ? Colors.green : Colors.red,
                              ),
                            ),
                            Text(
                              '${item.previousStock} → ${item.newStock}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStockColor(int stock) {
    if (stock > 50) return Colors.green;
    if (stock > 20) return Colors.orange;
    return Colors.red;
  }

  void _showStockDialog(bool isAdding) {
    _stockController.clear();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: .circular(16)),
        title: Text(isAdding ? 'Add Stock' : 'Remove Stock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity',
                hintText: 'Enter amount',
                prefixIcon: Icon(isAdding ? Icons.add : Icons.remove),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _updateStock(isAdding),
            style: ElevatedButton.styleFrom(
              backgroundColor: isAdding ? Colors.green : Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _updateStock(bool isAdding) async {
    final amount = int.tryParse(_stockController.text);
    
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid amount')),
      );
      return;
    }

    if (!isAdding && amount > widget.product.currentStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient stock')),
      );
      return;
    }

    Navigator.pop(context);

    final change = isAdding ? amount : -amount;
    final provider = context.read<ProductProvider>();
    
    await provider.updateStock(
      widget.product,
      change,
      isAdding ? 'Stock added' : 'Stock removed',
    );

    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Stock ${isAdding ? 'added' : 'removed'} successfully')),
      );
    }
  }

  void _editProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddProductScreen(product: widget.product),
      ),
    ).then((_) => setState(() {}));
  }

  void _deleteProduct() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: .circular(16)),
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<ProductProvider>().deleteProduct(widget.product);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product deleted')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}