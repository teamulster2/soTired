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
      fields[1] as QuestionnaireObject?,
      fields[2] as QuestionnaireObject?,
      fields[3] as QuestionnaireObject?,
      fields[4] as QuestionnaireObject?,
      fields[5] as QuestionnaireObject?,
    );
  }

  @override
  void write(BinaryWriter writer, QuestionnaireResult obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.question1)
      ..writeByte(2)
      ..write(obj.question2)
      ..writeByte(3)
      ..write(obj.question3)
      ..writeByte(4)
      ..write(obj.question4)
      ..writeByte(5)
      ..write(obj.question5);
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
