import 'package:hive/hive.dart';
import 'package:so_tired/ui/modules/questionnaire/widgets/questionnaire_answer.dart';
import 'package:so_tired/utils.dart';

part 'questionnaire_result.g.dart';

/// This class defines the [QuestionnaireResult] model by extending a
/// [HiveObject].
/// It holds an [uuid] and a [questions].
/// The UUID can be generated using the [Utils] class.
@HiveType(typeId: 3)
class QuestionnaireResult {
  @HiveField(0)
  String? uuid;

  @HiveField(1)
  Map<String, QuestionnaireAnswer?> questions;

  QuestionnaireResult(this.uuid, this.questions);

  QuestionnaireResult.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        questions = json['questions'];

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'uuid': uuid, 'questions': questions};

  @override
  String toString() => 'UUID: $uuid,\nQuestions: $questions';
}
