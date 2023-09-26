// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pptDetailsModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PPTDataDetailsAdapter extends TypeAdapter<PPTDataDetails> {
  @override
  final int typeId = 24;

  @override
  PPTDataDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PPTDataDetails()
      ..id = fields[0] as int
      ..title = fields[1] as String
      ..categoryId = fields[2] as int
      ..filename = fields[3] as String
      ..position = fields[4] as int
      ..status = fields[5] as int
      ..deleteStatus = fields[6] as int;
  }

  @override
  void write(BinaryWriter writer, PPTDataDetails obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.filename)
      ..writeByte(4)
      ..write(obj.position)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.deleteStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PPTDataDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
