import 'package:hive/hive.dart';
part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel extends HiveObject {
  @HiveField(0)
  String productId;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  int currentStock;

  @HiveField(4)
  String? imagePath;

  @HiveField(5)
  DateTime timeStamp;

  @HiveField(6)
  String addedBy;

  ProductModel({
    required this.productId,
    required this.name,
    required this.description,
    required this.currentStock,
    this.imagePath,
    required this.timeStamp,
     this.addedBy = 'Admin User',
  });
}
