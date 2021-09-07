import 'package:hive/hive.dart';

part 'current_activity.g.dart';

@HiveType(typeId: 2)
class CurrentActivity {
  @HiveField(0)
  String? uuid;

  @HiveField(1)
  String? currentActivity;

  @HiveField(2)
  String? currentMood;

  CurrentActivity(this.currentActivity, this.currentMood);

  @override
  String toString() => 'UUID: $uuid,\nCurrentActivity: $currentActivity,\n'
      'CurrentMood: $currentMood';
}
