// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsEntityAdapter extends TypeAdapter<SettingsEntity> {
  @override
  final int typeId = 1;

  @override
  SettingsEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsEntity(
      darkMode: fields[0] as bool,
      fontSize: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.darkMode)
      ..writeByte(1)
      ..write(obj.fontSize);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
