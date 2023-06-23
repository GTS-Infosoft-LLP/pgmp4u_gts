// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashCardModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlashCardDetailsAdapter extends TypeAdapter<FlashCardDetails> {
  @override
  final int typeId = 2;

  @override
  FlashCardDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlashCardDetails()
      ..id = fields[0] as int
      ..position = fields[1] as int
      ..categoryId = fields[2] as int
      ..description = fields[3] as String
      ..title = fields[4] as String
      ..thumbnail = fields[5] as String
      ..status = fields[6] as int
      ..deleteStatus = fields[7] as int;
  }

  @override
  void write(BinaryWriter writer, FlashCardDetails obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.position)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.thumbnail)
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
      other is FlashCardDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
