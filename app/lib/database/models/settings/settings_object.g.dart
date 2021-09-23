// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsObjectAdapter extends TypeAdapter<SettingsObject> {
  @override
  final int typeId = 7;

  @override
  SettingsObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsObject(
      fields[0] as String?,
      fields[1] as String?,
      fields[2] as String?,
      fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsObject obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.serverUrl)
      ..writeByte(1)
      ..write(obj.studyName)
      ..writeByte(2)
      ..write(obj.appVersion)
      ..writeByte(3)
      ..write(obj.clientUuid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
