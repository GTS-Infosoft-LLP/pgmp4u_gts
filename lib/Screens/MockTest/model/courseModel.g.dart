// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courseModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CourseDetailsAdapter extends TypeAdapter<CourseDetails> {
  @override
  final int typeId = 13;

  @override
  CourseDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CourseDetails()
      ..id = fields[0] as int
      ..course = fields[1] as String
      ..description = fields[2] as String
      ..exam_Time = fields[3] as String
      ..lable = fields[4] as String
      ..skip_content_progress = fields[5] as int
      ..status = fields[6] as int
      ..deleteStatus = fields[7] as int
      ..isSubscribed = fields[8] as int
      ..isChatSubscribed = fields[9] as int
      ..isJoinNotification = fields[10] as int
      ..subscriptionType = fields[11] as int
      ..Mocktests = (fields[12] as List)?.cast<dynamic>()
      ..isCancelSubscription = fields[13] as int
      ..inAppPurchaseEnabled = fields[14] as int
      ..subscriptionDurationType = fields[15] as int
      ..subscriptionDurationQuantity = fields[16] as int
      ..availableQuestionOfTheDay = fields[17] as int
      ..isFree = fields[18] as int;
  }

  @override
  void write(BinaryWriter writer, CourseDetails obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.course)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.exam_Time)
      ..writeByte(4)
      ..write(obj.lable)
      ..writeByte(5)
      ..write(obj.skip_content_progress)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.deleteStatus)
      ..writeByte(8)
      ..write(obj.isSubscribed)
      ..writeByte(9)
      ..write(obj.isChatSubscribed)
      ..writeByte(10)
      ..write(obj.isJoinNotification)
      ..writeByte(11)
      ..write(obj.subscriptionType)
      ..writeByte(12)
      ..write(obj.Mocktests)
      ..writeByte(13)
      ..write(obj.isCancelSubscription)
      ..writeByte(14)
      ..write(obj.inAppPurchaseEnabled)
      ..writeByte(15)
      ..write(obj.subscriptionDurationType)
      ..writeByte(16)
      ..write(obj.subscriptionDurationQuantity)
      ..writeByte(17)
      ..write(obj.availableQuestionOfTheDay)
      ..writeByte(18)
      ..write(obj.isFree);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
