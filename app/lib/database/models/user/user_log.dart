import 'package:hive/hive.dart';
import 'package:so_tired/utils.dart';
import 'package:so_tired/database/models/user/user_access_method.dart';
import 'package:so_tired/database/models/module_type.dart';

part 'user_log.g.dart';

/// This class defines the [UserLog] model by extending a [HiveObject].
/// It holds an [uuid], a [accessMethod], a [Map] defining which game the
/// user has executed and a [timestamp].
/// The UUID can be generated using the [Utils] class.
@HiveType(typeId: 1)
class UserLog extends HiveObject {
  @HiveField(0)
  String? uuid;

  @HiveField(1)
  UserAccessMethod? accessMethod;

  @HiveField(2)
  Map<ModuleType, Map<String, dynamic>>? gamesExecuted;

  @HiveField(3)
  DateTime? timestamp;

  UserLog(this.uuid, this.accessMethod, this.gamesExecuted, this.timestamp);

  UserLog.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        accessMethod = json['accessMethod'],
        gamesExecuted = json['gamesExecuted'],
        timestamp = json['timestamp'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uuid': uuid,
        'accessMethod': accessMethod,
        'gamesExecuted': gamesExecuted,
        'timestamp': timestamp
      };

  @override
  String toString() => 'UUID: $uuid,\nAccessMethod: $accessMethod,\n'
      'Which games have been executed?: $gamesExecuted,\n'
      'Timestamp: $timestamp';
}
