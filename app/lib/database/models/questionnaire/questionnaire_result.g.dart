// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionnaireResultAdapter extends TypeAdapter<QuestionnaireResult> {
  @override
  final int typeId = 3;

  @override
  QuestionnaireResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestionnaireResult(
      fields[0] as String?,
      (fields[1] as Map).cast<String, QuestionnaireAnswers?>(),
    );
  }

  @override
  void write(BinaryWriter writer, QuestionnaireResult obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.questions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionnaireResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
