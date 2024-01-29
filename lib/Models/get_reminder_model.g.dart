// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_reminder_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrentSubscriptionAdapter extends TypeAdapter<CurrentSubscription> {
  @override
  final int typeId = 30;

  @override
  CurrentSubscription read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentSubscription(
      id: fields[0] as int,
      title: fields[1] as String,
      price: fields[2] as String,
      courseId: fields[3] as int,
      planId: fields[4] as String,
      description: fields[5] as String,
      priceId: fields[6] as String,
      durationType: fields[7] as int,
      durationQuantity: fields[8] as int,
      days: fields[9] as int,
      chat: fields[10] as int,
      qOfDay: fields[11] as int,
      features: fields[12] as String,
      status: fields[13] as int,
      deleteStatus: fields[14] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CurrentSubscription obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.courseId)
      ..writeByte(4)
      ..write(obj.planId)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.priceId)
      ..writeByte(7)
      ..write(obj.durationType)
      ..writeByte(8)
      ..write(obj.durationQuantity)
      ..writeByte(9)
      ..write(obj.days)
      ..writeByte(10)
      ..write(obj.chat)
      ..writeByte(11)
      ..write(obj.qOfDay)
      ..writeByte(12)
      ..write(obj.features)
      ..writeByte(13)
      ..write(obj.status)
      ..writeByte(14)
      ..write(obj.deleteStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentSubscriptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
