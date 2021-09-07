import 'package:hive/hive.dart';
import 'package:so_tired/utils.dart';

part 'personal_score.g.dart';

/// This class defines the [PersonalScore] model by extending a [HiveObject].
/// It holds an [uuid] and a [gameScore].
/// The UUID can be generated using the [Utils] class.
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
