import 'package:hive/hive.dart';
import 'package:so_tired/database/models/user/user_access_method.dart';
import 'package:so_tired/database/models/user/user_game_execution.dart';

part 'user_log.g.dart';

@HiveType(typeId: 1)
class UserLog extends HiveObject {
  @HiveField(0)
  String? uuid;

  @HiveField(1)
  UserAccessMethod? accessMethod;

  @HiveField(2)
  Map<UserGameExecution, Map<String, dynamic>>? gameExecution;

  UserLog(this.uuid, this.accessMethod, this.gameExecution);

  @override
  String toString() => 'UUID: $uuid,\nAccessMethod: $accessMethod,\n'
      ' Which game has been executed?: $gameExecution';
}
