import 'package:hive/hive.dart';

part 'settings_object.g.dart';

@HiveType(typeId: 7)
class SettingsObject extends HiveObject {
  @HiveField(0)
  String? serverUrl;

  SettingsObject(this.serverUrl);

  SettingsObject.fromJson(Map<String, dynamic> json)
      : serverUrl = json['serverUrl'];

  Map<String, dynamic> toJson() => <String, dynamic>{'serverUrl': serverUrl};

  @override
  String toString() => 'ServerURL: $serverUrl';
}
