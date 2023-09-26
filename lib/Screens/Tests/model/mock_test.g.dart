// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_test.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MockTestListApiModelAdapter extends TypeAdapter<MockTestListApiModel> {
  @override
  final int typeId = 3;

  @override
  MockTestListApiModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MockTestListApiModel()
      ..id = fields[0] as int
      ..testName = fields[1] as String
      ..premium = fields[2] as int
      ..questionCount = fields[3] as int
      ..numAttemptes = fields[4] as int
      ..generated = fields[5] as int
      ..deleteStatus = fields[6] as int
      ..status = fields[7] as int
      ..AttemptList = fields[8] as String;
  }

  @override
  void write(BinaryWriter writer, MockTestListApiModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.testName)
      ..writeByte(2)
      ..write(obj.premium)
      ..writeByte(3)
      ..write(obj.questionCount)
      ..writeByte(4)
      ..write(obj.numAttemptes)
      ..writeByte(5)
      ..write(obj.generated)
      ..writeByte(6)
      ..write(obj.deleteStatus)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.AttemptList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MockTestListApiModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
