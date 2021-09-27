import 'package:hive/hive.dart';
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
  Map<String, String> questions;

  @HiveField(2)
  DateTime? timestamp;

  QuestionnaireResult(this.uuid, this.questions, this.timestamp);

  QuestionnaireResult.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        questions = json['questions'],
        timestamp = json['timestamp'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uuid': uuid,
        'questions': questions,
        'timestamp': timestamp
      };

  @override
  String toString() =>
      'UUID: $uuid,\nQuestions: $questions,\nTimestamp: $timestamp';
}
