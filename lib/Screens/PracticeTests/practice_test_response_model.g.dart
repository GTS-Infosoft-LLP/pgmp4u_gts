// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_test_response_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PracitceTextResponseModelListAdapter
    extends TypeAdapter<PracitceTextResponseModelList> {
  @override
  final int typeId = 5;

  @override
  PracitceTextResponseModelList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PracitceTextResponseModelList()..pracList = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, PracitceTextResponseModelList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.pracList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PracitceTextResponseModelListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
