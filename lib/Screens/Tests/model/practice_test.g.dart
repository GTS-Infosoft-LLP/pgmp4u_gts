// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_test.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PracticeListModelAdapter extends TypeAdapter<PracticeListModel> {
  @override
  final int typeId = 4;

  @override
  PracticeListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PracticeListModel()
      ..id = fields[0] as int
      ..questionNo = fields[1] as int
      ..course = fields[2] as int
      ..category = fields[3] as int
      ..question = fields[4] as String
      ..questionType = fields[5] as String
      ..rightAnswer = fields[6] as int
      ..explanation = fields[7] as String
      ..image = fields[8] as String
      ..status = fields[9] as int
      ..deleteStatus = fields[10] as int
      ..options = (fields[11] as List)?.cast<Options>();
  }

  @override
  void write(BinaryWriter writer, PracticeListModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.questionNo)
      ..writeByte(2)
      ..write(obj.course)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.question)
      ..writeByte(5)
      ..write(obj.questionType)
      ..writeByte(6)
      ..write(obj.rightAnswer)
      ..writeByte(7)
      ..write(obj.explanation)
      ..writeByte(8)
      ..write(obj.image)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.deleteStatus)
      ..writeByte(11)
      ..write(obj.options);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PracticeListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
