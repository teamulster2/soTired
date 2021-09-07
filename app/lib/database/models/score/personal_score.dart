import 'package:hive/hive.dart';

part 'personal_score.g.dart';

@HiveType(typeId: 0)
class PersonalScore extends HiveObject {
  @HiveField(0)
  String? uuid;

  @HiveField(1)
  int? gameScore;

  PersonalScore(this.uuid, this.gameScore);

  @override
  String toString() => 'UUID: $uuid,\nGameScore: $gameScore';
}
