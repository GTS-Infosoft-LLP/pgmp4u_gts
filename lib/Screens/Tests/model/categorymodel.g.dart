// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categorymodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryListModelAdapter extends TypeAdapter<CategoryListModel> {
  @override
  final int typeId = 1;

  @override
  CategoryListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryListModel()
      ..id = fields[0] as int
      ..course = fields[1] as int
      ..mainCategory = fields[2] as String
      ..type = fields[3] as String
      ..webType = fields[4] as String
      ..paymentStatus = fields[5] as int
      ..price = fields[6] as String
      ..status = fields[7] as int
      ..icon = fields[8] as String;
  }

  @override
  void write(BinaryWriter writer, CategoryListModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.course)
      ..writeByte(2)
      ..write(obj.mainCategory)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.webType)
      ..writeByte(5)
      ..write(obj.paymentStatus)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
