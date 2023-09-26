// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mockListmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MockDataDetailsAdapter extends TypeAdapter<MockDataDetails> {
  @override
  final int typeId = 17;

  @override
  MockDataDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MockDataDetails()
      ..id = fields[0] as int
      ..course = fields[1] as int
      ..test_name = fields[2] as String
      ..premium = fields[3] as int
      ..price = fields[4] as int
      ..question_count = fields[5] as int
      ..num_attemptes = fields[6] as int
      ..generated = fields[7] as int
      ..status = fields[8] as int
      ..deleteStatus = fields[9] as int;
  }

  @override
  void write(BinaryWriter writer, MockDataDetails obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.question_count)
      ..writeByte(6)
      ..write(obj.num_attemptes)
      ..writeByte(7)
      ..write(obj.generated)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.deleteStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MockDataDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
