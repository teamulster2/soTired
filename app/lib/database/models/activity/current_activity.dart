import 'package:hive/hive.dart';
import 'package:so_tired/utils.dart';

part 'current_activity.g.dart';

/// This class defines the [CurrentActivity] model by extending a [HiveObject].
/// It holds an [uuid], a [currentActivity] and a [currentMood].
/// The UUID can be generated using the [Utils] class.
@HiveType(typeId: 2)
class CurrentActivity {
  @HiveField(0)
  String? uuid;

  @HiveField(1)
  String? currentActivity;

  @HiveField(2)
  String? currentMood;

  CurrentActivity(this.uuid, this.currentActivity, this.currentMood);

  @override
  String toString() => 'UUID: $uuid,\nCurrentActivity: $currentActivity,\n'
      'CurrentMood: $currentMood';
}
