// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashCateModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlashCateDetailsAdapter extends TypeAdapter<FlashCateDetails> {
  @override
  final int typeId = 14;

  @override
  FlashCateDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlashCateDetails()
      ..id = fields[0] as int
      ..name = fields[1] as String
      ..position = fields[2] as int
      ..courseId = fields[3] as int
      ..masterList = fields[4] as int
      ..payment_status = fields[5] as int
      ..price = fields[6] as String
      ..status = fields[7] as int
      ..deleteStatus = fields[8] as int;
  }

  @override
  void write(BinaryWriter writer, FlashCateDetails obj) {
    writer
      ..writeByte(9)
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
      ..write(obj.payment_status)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.deleteStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlashCateDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
