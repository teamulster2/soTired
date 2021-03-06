// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStateAdapter extends TypeAdapter<UserState> {
  @override
  final int typeId = 2;

  @override
  UserState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserState(
      fields[0] as String?,
      fields[1] as String?,
      fields[2] as String?,
      fields[3] as DateTime?,
      fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserState obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.currentActivity)
      ..writeByte(2)
      ..write(obj.currentMood)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.selfTestUuid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
