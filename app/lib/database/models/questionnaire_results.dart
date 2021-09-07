import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class QuestionnaireResults {
  // TODO: change after rebase to QuestionnaireObject
  @HiveField(0)
  String? questions;
}