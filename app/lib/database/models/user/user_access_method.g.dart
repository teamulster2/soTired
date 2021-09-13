// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_access_method.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAccessMethodAdapter extends TypeAdapter<UserAccessMethod> {
  @override
  final int typeId = 5;

  @override
  UserAccessMethod read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserAccessMethod.notification;
      case 1:
        return UserAccessMethod.regularAppStart;
      case 2:
        return UserAccessMethod.inviteUrl;
      default:
        return UserAccessMethod.notification;
    }
  }

  @override
  void write(BinaryWriter writer, UserAccessMethod obj) {
    switch (obj) {
      case UserAccessMethod.notification:
        writer.writeByte(0);
        break;
      case UserAccessMethod.regularAppStart:
        writer.writeByte(1);
        break;
      case UserAccessMethod.inviteUrl:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAccessMethodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
