// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_high_score.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonalHighScoreAdapter extends TypeAdapter<PersonalHighScore> {
  @override
  final int typeId = 0;

  @override
  PersonalHighScore read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonalHighScore(
      fields[0] as String?,
      fields[1] as int?,
      fields[2] as UserGameType?,
    );
  }

  @override
  void write(BinaryWriter writer, PersonalHighScore obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.gameScore)
      ..writeByte(2)
      ..write(obj.gameType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalHighScoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
