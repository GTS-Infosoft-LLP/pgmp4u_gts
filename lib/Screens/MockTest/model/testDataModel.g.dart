// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'testDataModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TestDataDetailsAdapter extends TypeAdapter<TestDataDetails> {
  @override
  final int typeId = 15;

  @override
  TestDataDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TestDataDetails()
      ..id = fields[0] as int
      ..course = fields[1] as int
      ..test_name = fields[2] as String
      ..premium = fields[3] as int
      ..price = fields[4] as String
      ..masterList = fields[5] as int
      ..type = fields[6] as String
      ..question_count = fields[7] as String
      ..num_attemptes = fields[8] as int
      ..generated = fields[9] as int
      ..status = fields[10] as int
      ..deleteStatus = fields[11] as int;
  }

  @override
  void write(BinaryWriter writer, TestDataDetails obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.course)
      ..writeByte(2)
      ..write(obj.test_name)
      ..writeByte(3)
      ..write(obj.premium)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.masterList)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.question_count)
      ..writeByte(8)
      ..write(obj.num_attemptes)
      ..writeByte(9)
      ..write(obj.generated)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.deleteStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestDataDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
