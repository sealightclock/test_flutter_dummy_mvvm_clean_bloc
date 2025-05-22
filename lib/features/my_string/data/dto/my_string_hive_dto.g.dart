// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_string_hive_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyStringHiveDtoAdapter extends TypeAdapter<MyStringHiveDto> {
  @override
  final int typeId = 0;

  @override
  MyStringHiveDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyStringHiveDto(
      value: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MyStringHiveDto obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyStringHiveDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
