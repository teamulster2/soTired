import 'package:hive/hive.dart';
import 'package:so_tired/utils/utils.dart';

part 'user_state.g.dart';

/// This class defines the [UserState] model by extending a [HiveObject].
/// It holds an [uuid], a [currentActivity] and a [currentMood] containing
/// a [List] of type [int] which represents necessary codeUnits to be converted
/// into a [String].
/// The UUID can be generated using the [Utils] class.
@HiveType(typeId: 2)
class UserState extends HiveObject {
  @HiveField(0)
  String? uuid;

  @HiveField(1)
  List<int>? currentActivity;

  @HiveField(2)
  List<int>? currentMood;

  @HiveField(3)
  DateTime? timestamp;

  @HiveField(4)
  String? selfTestUuid;

  UserState(this.uuid, this.currentActivity, this.currentMood, this.timestamp,
      this.selfTestUuid);

  UserState.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        currentActivity = json['currentActivity'],
        currentMood = json['currentMood'],
        timestamp = json['timestamp'],
        selfTestUuid = json['selfTestUuid'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uuid': uuid,
        'currentActivity': currentActivity,
        'currentMood': currentMood,
        'timestamp': timestamp,
        'selfTestUuid': selfTestUuid
      };

  @override
  String toString() => 'UUID: $uuid,\n'
      'CurrentActivity: $currentActivity,\n'
      'CurrentMood: $currentMood,\n'
      'Timestamp: $timestamp,\n'
      'SelfTestUuid: $selfTestUuid';
}
