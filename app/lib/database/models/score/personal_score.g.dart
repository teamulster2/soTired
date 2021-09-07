// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_score.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonalScoreAdapter extends TypeAdapter<PersonalScore> {
  @override
  final int typeId = 0;

  @override
  PersonalScore read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonalScore(
      fields[0] as String?,
      fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, PersonalScore obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.gameScore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalScoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
