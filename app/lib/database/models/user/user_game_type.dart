import 'package:hive/hive.dart';

part 'user_game_type.g.dart';

/// This enum defines which games are available / have been executed.
@HiveType(typeId: 6)
enum UserGameType {
  @HiveField(0)
  spatialSpanTask,
  @HiveField(1)
  psychomotorVigilanceTask
}
