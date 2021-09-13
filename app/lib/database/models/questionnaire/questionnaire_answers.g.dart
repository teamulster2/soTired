// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire_answers.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionnaireAnswersAdapter extends TypeAdapter<QuestionnaireAnswers> {
  @override
  final int typeId = 4;

  @override
  QuestionnaireAnswers read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuestionnaireAnswers.first;
      case 1:
        return QuestionnaireAnswers.second;
      case 2:
        return QuestionnaireAnswers.third;
      case 3:
        return QuestionnaireAnswers.fourth;
      default:
        return QuestionnaireAnswers.first;
    }
  }

  @override
  void write(BinaryWriter writer, QuestionnaireAnswers obj) {
    switch (obj) {
      case QuestionnaireAnswers.first:
        writer.writeByte(0);
        break;
      case QuestionnaireAnswers.second:
        writer.writeByte(1);
        break;
      case QuestionnaireAnswers.third:
        writer.writeByte(2);
        break;
      case QuestionnaireAnswers.fourth:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionnaireAnswersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
