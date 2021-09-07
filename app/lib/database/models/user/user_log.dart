import 'package:hive/hive.dart';
import 'package:so_tired/database/models/user/user_access_method.dart';
import 'package:so_tired/database/models/user/user_game_execution.dart';

@HiveType(typeId: 1)
class UserLog extends HiveObject {
  @HiveField(0)
  UserAccessMethod? accessMethod;

  @HiveField(1)
  Map<UserGameExecution, Map<String, dynamic>>? gameExecution;
}