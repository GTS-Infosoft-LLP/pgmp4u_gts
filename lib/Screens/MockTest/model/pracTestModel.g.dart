// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pracTestModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PracListModelAdapter extends TypeAdapter<PracListModel> {
  @override
  final int typeId = 6;

  @override
  PracListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PracListModel()..myList = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, PracListModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.myList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PracListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
