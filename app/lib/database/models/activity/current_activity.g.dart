// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_activity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrentActivityAdapter extends TypeAdapter<CurrentActivity> {
  @override
  final int typeId = 2;

  @override
  CurrentActivity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentActivity(
      fields[0] as String?,
      fields[1] as String?,
      fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CurrentActivity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.currentActivity)
      ..writeByte(2)
      ..write(obj.currentMood);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
