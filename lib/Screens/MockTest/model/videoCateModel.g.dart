// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'videoCateModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoCateDetailsAdapter extends TypeAdapter<VideoCateDetails> {
  @override
  final int typeId = 26;

  @override
  VideoCateDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoCateDetails()
      ..id = fields[0] as int
      ..name = fields[1] as String
      ..position = fields[2] as int
      ..courseId = fields[3] as int
      ..masterList = fields[4] as int
      ..payment_status = fields[5] as int
      ..price = fields[6] as String
      ..status = fields[7] as int
      ..deleteStatus = fields[8] as int
      ..videoLibraries = fields[9] as int;
  }

  @override
  void write(BinaryWriter writer, VideoCateDetails obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.deleteStatus)
      ..writeByte(9)
      ..write(obj.videoLibraries);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoCateDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
