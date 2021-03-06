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
          MapEntry(k as UserGameType, (v as Map).cast<String, dynamic>())),
      fields[3] as DateTime?,
      fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserLog obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.accessMethod)
      ..writeByte(2)
      ..write(obj.gamesExecuted)
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
      other is UserLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
