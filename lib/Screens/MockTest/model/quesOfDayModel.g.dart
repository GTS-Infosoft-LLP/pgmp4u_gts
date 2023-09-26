// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quesOfDayModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AllDayQuestionModelAdapter extends TypeAdapter<AllDayQuestionModel> {
  @override
  final int typeId = 25;

  @override
  AllDayQuestionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AllDayQuestionModel()..myList = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, AllDayQuestionModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.myList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllDayQuestionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
