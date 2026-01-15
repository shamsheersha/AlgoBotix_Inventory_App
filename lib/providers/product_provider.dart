import 'package:algobotix_inventory_app/models/product/product_model.dart';
import 'package:algobotix_inventory_app/models/stock_history/stock_history_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class ProductProvider extends ChangeNotifier {
  late Box<ProductModel> productBox;
  late Box<StockHistoryModel> stockHistoryBox;

  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  String searchQuery = '';

  ProductProvider() {
    productBox = Hive.box<ProductModel>('products');
    stockHistoryBox = Hive.box<StockHistoryModel>('stock_history');
    loadProducts();
  }

  List<ProductModel> get products =>
      filteredProducts.isEmpty && searchQuery.isEmpty
      ? allProducts
      : filteredProducts;

  void loadProducts() {
    allProducts = productBox.values.toList();
    sortProducts();
    notifyListeners();
  }

  void sortProducts() {
    allProducts.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
  }

  Future<bool> addProduct(ProductModel product) async {
    if (allProducts.any((p) => p.productId == product.productId)) {
      return false;
    }

    await productBox.add(product);

    final stockHistory = StockHistoryModel(
      productId: product.productId,
      changeAmount: product.currentStock,
      previousStock: 0,
      newStock: product.currentStock,
      timestamp: DateTime.now(),
      reason: 'Initial stock',
    );

    await stockHistoryBox.add(stockHistory);
    loadProducts();
    return true;
  }

  Future<void> updateProduct(ProductModel product) async {
    await product.save();
  }

  Future<void> deleteProduct(ProductModel product) async {
    final historyToDelete = stockHistoryBox.values
        .where((id) => id.productId == product.productId)
        .toList();

    for (var history in historyToDelete) {
      await history.delete();
    }

    await product.delete();
    loadProducts();
  }

  Future<void> updateStock(
    ProductModel product,
    int change,
    String reason,
  ) async {
    final previousStock = product.currentStock;
    product.currentStock += change;

    await product.save();

    final history = StockHistoryModel(
      productId: product.productId,
      changeAmount: change,
      previousStock: previousStock,
      newStock: product.currentStock,
      timestamp: DateTime.now(),
      reason: reason,
    );

    await stockHistoryBox.add(history);
    loadProducts();
  }

  List<StockHistoryModel> getProductHistory(String productId) {
    return stockHistoryBox.values
        .where((id) => id.productId == productId)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  void searchProducts(String query) {
    searchQuery = query.trim().toUpperCase();

    if (searchQuery.isEmpty) {
      filteredProducts = [];
    } else {
      filteredProducts = allProducts
          .where((p) => p.productId.toUpperCase().contains(searchQuery))
          .toList();
    }
    notifyListeners();
  }

  ProductModel? getProductById(String productId) {
    try {
      return allProducts.firstWhere(
        (p) => p.productId.toUpperCase() == productId.toUpperCase(),
      );
    } catch (e) {
      return null;
    }
  }

  bool isProductIdUnique(String productId, {String? excludeId}) {
    return !allProducts.any(
      (p) =>
          p.productId.toUpperCase() == productId.toUpperCase() &&
          p.productId != excludeId,
    );
  }
}
