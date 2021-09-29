import 'package:hive/hive.dart';
import 'package:so_tired/database/models/user/user_game_type.dart';
import 'package:so_tired/utils/utils.dart';

part 'personal_high_score.g.dart';

/// This class defines the [PersonalHighScore] model by extending a [HiveObject].
/// It holds an [uuid], a [gameScore] and a [gameType].
/// The UUID can be generated using the [Utils] class.
@HiveType(typeId: 0)
class PersonalHighScore extends HiveObject {
  @HiveField(0)
  String? uuid;

  @HiveField(1)
  int? gameScore;

  @HiveField(2)
  UserGameType? gameType;

  PersonalHighScore(this.uuid, this.gameScore, this.gameType);

  PersonalHighScore.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        gameScore = json['gameScore'],
        gameType = json['gameType'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uuid': uuid,
        'gameScore': gameScore,
        'gameType': gameType
      };

  @override
  String toString() => 'UUID: $uuid,\nGameScore: $gameScore,'
      '\nGameExecution: $gameType';
}
