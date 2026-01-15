import 'dart:io';

import 'package:algobotix_inventory_app/models/product/product_model.dart';
import 'package:algobotix_inventory_app/providers/product_provider.dart';
import 'package:algobotix_inventory_app/screens/add_product_screen.dart';
import 'package:algobotix_inventory_app/screens/product_detail_screen.dart';
import 'package:algobotix_inventory_app/screens/qr_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = .new();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(child: _buildProductList()),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddProductScreen()));
        },
        label: const Text('Add Product'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const .all(24),
      child: Row(
        children: [
          Container(
            padding: .all(12),
            decoration: BoxDecoration(
              borderRadius: .circular(12),
              color: const Color(0xFF6366F1).withOpacity(0.1),
            ),
            child: const Icon(
              Icons.inventory_2_rounded,
              color: Color(0xFF6366F1),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  'AlgoBotix',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontWeight: .bold),
                ),
                Text(
                  'Inventory Manager',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Consumer<ProductProvider>(
            builder: (context, provider, child) {
              return Container(
                padding: .symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: .circular(20),
                ),
                child: Text(
                  '${provider.products.length} Items',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: .w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: .symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          context.read<ProductProvider>().searchProducts('');
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
              ),
              onChanged: (value) {
                context.read<ProductProvider>().searchProducts(value);
              },
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF6366F1),
              borderRadius: .circular(12),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> QRScannerScreen()));
              },
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        if (provider.products.isEmpty) {
          return _buildEmptyState();
        }
        return ListView.builder(
          padding: .all(24),
          itemCount: provider.products.length,
          itemBuilder: (context, index) {
            final product = provider.products[index];
            return _buildProductCard(product);
          },
        );
      },
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Card(
      margin: const .only(bottom: 16),
      color: Colors.grey[100],
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProductDetailScreen(product: product)));
        },
        borderRadius: .circular(16),
        child: Padding(
          padding: const .all(16),
          child: Row(
            children: [
              _buildProductImage(product),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const .symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withOpacity(0.1),
                            borderRadius: .circular(6),
                          ),
                          child: Text(
                            product.productId,
                            style: const TextStyle(
                              color: Color(0xFF6366F1),
                              fontWeight: .bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Spacer(),
                        _buildStockBadge(product.currentStock),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: .w600,
                      ),
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: .ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey[400]),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM dd, yyyy').format(product.timeStamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildProductImage(ProductModel product) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: .circular(12),
      ),
      child: product.imagePath != null && File(product.imagePath!).existsSync()
          ? ClipRRect(
              borderRadius: .circular(12),
              child: Image.file(File(product.imagePath!), fit: .cover),
            )
          : Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey[400]),
    );
  }

  Widget _buildStockBadge(int stock) {
    final color = stock > 50
        ? Colors.green
        : stock > 20
            ? Colors.orange
            : Colors.red;

    return Container(
      padding: const .symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: .circular(20),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Icon(Icons.inventory, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '$stock',
            style: TextStyle(
              color: color,
              fontWeight: .bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 24),
          Text(
            'No Products Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: .w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the button below to add your first product',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
