import 'package:hive_flutter/adapters.dart';
part 'stock_history_model.g.dart';
@HiveType(typeId: 1)
class StockHistoryModel extends HiveObject {
  @HiveField(0)
  String productId;

  @HiveField(1)
  int changeAmount;

  @HiveField(2)
  int previousStock;

  @HiveField(3)
  int newStock;

  @HiveField(4)
  DateTime timestamp;

  @HiveField(5)
  String reason;

  StockHistoryModel({
    required this.productId,
    required this.changeAmount,
    required this.previousStock,
    required this.newStock,
    required this.timestamp,
    this.reason = 'Stock adjustment',
  });
}
