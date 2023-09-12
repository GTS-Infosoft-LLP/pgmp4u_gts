// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restartModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestartModelAdapter extends TypeAdapter<RestartModel> {
  @override
  final int typeId = 18;

  @override
  RestartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestartModel(
      restartAttempNum: fields[0] as int,
      displayTime: fields[1] as String,
      quesNum: fields[2] as int,
      answersMapp: (fields[3] as List)
          ?.map((dynamic e) => (e as Map)?.cast<String, dynamic>())
          ?.toList(),
    );
  }

  @override
  void write(BinaryWriter writer, RestartModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.restartAttempNum)
      ..writeByte(1)
      ..write(obj.displayTime)
      ..writeByte(2)
      ..write(obj.quesNum)
      ..writeByte(3)
      ..write(obj.answersMapp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
