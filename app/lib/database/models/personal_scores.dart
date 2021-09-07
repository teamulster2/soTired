import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class PersonalScores extends HiveObject {

  @HiveField(0)
  int? gameId;

  @HiveField(1)
  int? gameScore;
}