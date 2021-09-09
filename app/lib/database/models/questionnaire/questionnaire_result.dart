import 'package:hive/hive.dart';
import 'package:so_tired/database/models/questionnaire/questionnaire_object.dart';
import 'package:so_tired/utils.dart';

part 'questionnaire_result.g.dart';

/// This class defines the [QuestionnaireResult] model by extending a
/// [HiveObject].
/// It holds an [uuid] and a [QuestionnaireObject].
/// The UUID can be generated using the [Utils] class.
@HiveType(typeId: 3)
class QuestionnaireResult {
  @HiveField(0)
  String? uuid;

  @HiveField(1)
  List<QuestionnaireObject?> questions;

  QuestionnaireResult(this.uuid, this.questions);

  @override
  String toString() => 'UUID: $uuid,\nQuestion1: $questions';
}
