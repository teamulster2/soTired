import 'package:hive_flutter/adapters.dart';

part 'user_access_method.g.dart';

/// This enum defines which method the user can choose to access the app.
@HiveType(typeId: 5)
enum UserAccessMethod {
  @HiveField(0)
  notification,
  @HiveField(1)
  regularAppStart,
  @HiveField(2)
  inviteUrl
}
