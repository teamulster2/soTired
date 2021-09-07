import 'package:hive/hive.dart';
import 'package:so_tired/ui/models/questionnaire.dart';

part 'questionnaire_result.g.dart';

@HiveType(typeId: 3)
class QuestionnaireResult {
  @HiveField(0)
  String? uuid;

  @HiveField(1)
  QuestionnaireObject? question1;

  @HiveField(2)
  QuestionnaireObject? question2;

  @HiveField(3)
  QuestionnaireObject? question3;

  @HiveField(4)
  QuestionnaireObject? question4;

  @HiveField(5)
  QuestionnaireObject? question5;

  QuestionnaireResult(this.uuid, this.question1, this.question2,
      this.question3, this.question4, this.question5);

  @override
  String toString() => 'UUID: $uuid,\nQuestion1: $question1,\n'
      'Question2: $question2,\nQuestion3: $question3,\n'
      'Question4: $question4,\nQuestion5: $question5';
}
