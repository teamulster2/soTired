import 'package:hive/hive.dart';
import 'package:so_tired/database/models/questionnaire/questionnaire_answers.dart';
import 'package:so_tired/utils/utils.dart';

part 'questionnaire_result.g.dart';

/// This class defines the [QuestionnaireResult] model by extending a
/// [HiveObject].
/// It holds an [uuid] and [questions].
/// The UUID can be generated using the [Utils] class.
@HiveType(typeId: 3)
class QuestionnaireResult extends HiveObject {
  @HiveField(0)
  String? uuid;

  @HiveField(1)
  Map<String, QuestionnaireAnswers?> questions;

  QuestionnaireResult(this.uuid, this.questions);

  QuestionnaireResult.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        questions = json['questions'];

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'uuid': uuid, 'questions': questions};

  @override
  String toString() => 'UUID: $uuid,\nQuestions: $questions';
}
