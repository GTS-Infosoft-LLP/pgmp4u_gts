// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subprocess_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubProcessDetailsAdapter extends TypeAdapter<SubProcessDetails> {
  @override
  final int typeId = 29;

  @override
  SubProcessDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubProcessDetails()
      ..id = fields[0] as int
      ..name = fields[1] as String
      ..lable = fields[2] as String
      ..position = fields[3] as int
      ..processId = fields[4] as int
      ..masterList = fields[5] as int
      ..status = fields[6] as int
      ..deleteStatus = fields[7] as int
      ..TaskProceesses = fields[8] as int;
  }

  @override
  void write(BinaryWriter writer, SubProcessDetails obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.lable)
      ..writeByte(3)
      ..write(obj.position)
      ..writeByte(4)
      ..write(obj.processId)
      ..writeByte(5)
      ..write(obj.masterList)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.deleteStatus)
      ..writeByte(8)
      ..write(obj.TaskProceesses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubProcessDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
