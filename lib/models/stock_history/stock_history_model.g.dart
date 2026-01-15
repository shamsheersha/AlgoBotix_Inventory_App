// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockHistoryModelAdapter extends TypeAdapter<StockHistoryModel> {
  @override
  final int typeId = 1;

  @override
  StockHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockHistoryModel(
      productId: fields[0] as String,
      changeAmount: fields[1] as int,
      previousStock: fields[2] as int,
      newStock: fields[3] as int,
      timestamp: fields[4] as DateTime,
      reason: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StockHistoryModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.changeAmount)
      ..writeByte(2)
      ..write(obj.previousStock)
      ..writeByte(3)
      ..write(obj.newStock)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.reason);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
