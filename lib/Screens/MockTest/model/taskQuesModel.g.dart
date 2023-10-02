// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taskQuesModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskQuesAdapter extends TypeAdapter<TaskQues> {
  @override
  final int typeId = 27;

  @override
  TaskQues read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskQues()
      ..id = fields[0] as int
      ..questionNo = fields[1] as int
      ..course = fields[2] as int
      ..category = fields[3] as int
      ..question = fields[4] as String
      ..domain = fields[5] as String
      ..questionType = fields[6] as String
      ..rightAnswer = fields[7] as String
      ..explanation = fields[8] as String
      ..image = fields[9] as String
      ..isSent = fields[10] as int
      ..sendDate = fields[11] as String
      ..status = fields[12] as int
      ..deleteStatus = fields[13] as int
      ..sendDateFormat = fields[14] as String
      ..options = (fields[15] as List)?.cast<TaskQuesOption>();
  }

  @override
  void write(BinaryWriter writer, TaskQues obj) {
    writer
      ..writeByte(16)
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
      ..write(obj.domain)
      ..writeByte(6)
      ..write(obj.questionType)
      ..writeByte(7)
      ..write(obj.rightAnswer)
      ..writeByte(8)
      ..write(obj.explanation)
      ..writeByte(9)
      ..write(obj.image)
      ..writeByte(10)
      ..write(obj.isSent)
      ..writeByte(11)
      ..write(obj.sendDate)
      ..writeByte(12)
      ..write(obj.status)
      ..writeByte(13)
      ..write(obj.deleteStatus)
      ..writeByte(14)
      ..write(obj.sendDateFormat)
      ..writeByte(15)
      ..write(obj.options);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskQuesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
