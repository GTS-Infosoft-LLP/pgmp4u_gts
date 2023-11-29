// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processTask_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AllProcessTaskModelAdapter extends TypeAdapter<AllProcessTaskModel> {
  @override
  final int typeId = 21;

  @override
  AllProcessTaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AllProcessTaskModel()..myList = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, AllProcessTaskModel obj) {
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
      other is AllProcessTaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
