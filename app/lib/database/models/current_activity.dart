import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class CurrentActivity {
  @HiveField(0)
  String? currentActivity;

  @HiveField(1)
  String? currentMood;
}