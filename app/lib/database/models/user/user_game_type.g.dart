// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_game_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserGameTypeAdapter extends TypeAdapter<UserGameType> {
  @override
  final int typeId = 6;

  @override
  UserGameType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserGameType.spatialSpanTask;
      case 1:
        return UserGameType.psychomotorVigilanceTask;
      default:
        return UserGameType.spatialSpanTask;
    }
  }

  @override
  void write(BinaryWriter writer, UserGameType obj) {
    switch (obj) {
      case UserGameType.spatialSpanTask:
        writer.writeByte(0);
        break;
      case UserGameType.psychomotorVigilanceTask:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserGameTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
