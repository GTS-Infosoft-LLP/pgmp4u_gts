// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subDomainModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubDomainDetailsAdapter extends TypeAdapter<SubDomainDetails> {
  @override
  final int typeId = 22;

  @override
  SubDomainDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubDomainDetails()
      ..id = fields[0] as int
      ..name = fields[1] as String
      ..lable = fields[2] as String
      ..position = fields[3] as int
      ..domainId = fields[4] as int
      ..status = fields[5] as int
      ..deleteStatus = fields[6] as int
      ..Tasks = fields[7] as int;
  }

  @override
  void write(BinaryWriter writer, SubDomainDetails obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.lable)
      ..writeByte(3)
      ..write(obj.position)
      ..writeByte(4)
      ..write(obj.domainId)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.deleteStatus)
      ..writeByte(7)
      ..write(obj.Tasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubDomainDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
