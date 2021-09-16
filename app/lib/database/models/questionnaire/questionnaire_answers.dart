import 'package:hive/hive.dart';

part 'questionnaire_answers.g.dart';

/// This enum defines which answer (per question) has been selected.
@HiveType(typeId: 4)
enum QuestionnaireAnswers {
  @HiveField(0)
  first,
  @HiveField(1)
  second,
  @HiveField(2)
  third,
  @HiveField(3)
  fourth
}
