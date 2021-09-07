// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserLogAdapter extends TypeAdapter<UserLog> {
  @override
  final int typeId = 1;

  @override
  UserLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserLog(
      fields[0] as String?,
      fields[1] as UserAccessMethod?,
      (fields[2] as Map?)?.map((dynamic k, dynamic v) =>
          MapEntry(k as UserGameExecution, (v as Map).cast<String, dynamic>())),
    );
  }

  @override
  void write(BinaryWriter writer, UserLog obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.accessMethod)
      ..writeByte(2)
      ..write(obj.gameExecution);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
