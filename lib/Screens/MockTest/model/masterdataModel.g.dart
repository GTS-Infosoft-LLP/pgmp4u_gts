// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'masterdataModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MasterDetailsAdapter extends TypeAdapter<MasterDetails> {
  @override
  final int typeId = 12;

  @override
  MasterDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MasterDetails()
      ..id = fields[0] as int
      ..name = fields[1] as String
      ..type = fields[2] as String
      ..position = fields[3] as int
      ..label = fields[4] as String
      ..courseId = fields[5] as int
      ..status = fields[6] as int
      ..deleteStatus = fields[7] as int;
  }

  @override
  void write(BinaryWriter writer, MasterDetails obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.position)
      ..writeByte(4)
      ..write(obj.label)
      ..writeByte(5)
      ..write(obj.courseId)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.deleteStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MasterDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
