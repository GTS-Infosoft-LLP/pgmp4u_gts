// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pptCateModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PPTCateDetailsAdapter extends TypeAdapter<PPTCateDetails> {
  @override
  final int typeId = 23;

  @override
  PPTCateDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PPTCateDetails()
      ..id = fields[0] as int
      ..name = fields[1] as String
      ..position = fields[2] as int
      ..courseId = fields[3] as int
      ..masterList = fields[4] as int
      ..paymentStatus = fields[5] as int
      ..price = fields[6] as String
      ..label = fields[7] as String
      ..status = fields[8] as int
      ..deleteStatus = fields[9] as int
      ..pptLibraries = fields[10] as int;
  }

  @override
  void write(BinaryWriter writer, PPTCateDetails obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.position)
      ..writeByte(3)
      ..write(obj.courseId)
      ..writeByte(4)
      ..write(obj.masterList)
      ..writeByte(5)
      ..write(obj.paymentStatus)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.label)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.deleteStatus)
      ..writeByte(10)
      ..write(obj.pptLibraries);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PPTCateDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
