import 'package:hive/hive.dart';
import 'package:so_tired/utils.dart';

part 'user_state.g.dart';

/// This class defines the [UserState] model by extending a [HiveObject].
/// It holds an [uuid], a [currentActivity] and a [currentMood] containing
/// a [List] of type [int] which represents necessary codeUnits to be converted
/// into a [String].
/// The UUID can be generated using the [Utils] class.
@HiveType(typeId: 2)
class UserState {
  @HiveField(0)
  String? uuid;

  @HiveField(1)
  String? currentActivity;

  @HiveField(2)
  List<int>? currentMood;

  UserState(this.uuid, this.currentActivity, this.currentMood);

  UserState.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        currentActivity = json['currentActivity'],
        currentMood = json['currentMood'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uuid': uuid,
        'currentActivity': currentActivity,
        'currentMood': currentMood
      };

  @override
  String toString() => 'UUID: $uuid,\nCurrentActivity: $currentActivity,\n'
      'CurrentMood: $currentMood';
}
