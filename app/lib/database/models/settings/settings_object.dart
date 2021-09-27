import 'package:hive/hive.dart';

part 'settings_object.g.dart';

/// This class defines the [SettingsObject] model by extending a
/// [HiveObject].
/// It holds the current [serverUrl].
@HiveType(typeId: 7)
class SettingsObject extends HiveObject {
  @HiveField(0)
  String? serverUrl;

  @HiveField(1)
  String? studyName;

  @HiveField(2)
  String? appVersion;

  @HiveField(3)
  String? clientUuid;

  @HiveField(4)
  Map<String, dynamic>? latestDatabaseExport;

  SettingsObject(this.serverUrl, this.studyName, this.appVersion,
      this.clientUuid, this.latestDatabaseExport);

  SettingsObject.fromJson(Map<String, dynamic> json)
      : serverUrl = json['serverUrl'],
        studyName = json['studyName'],
        appVersion = json['appVersion'],
        clientUuid = json['clientUuid'],
        latestDatabaseExport = json['latestDatabaseExport'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'serverUrl': serverUrl,
        'studyName': studyName,
        'appVersion': appVersion,
        'clientUuid': clientUuid,
        'latestDatabaseExport': latestDatabaseExport
      };

  @override
  String toString() => 'ServerURL: $serverUrl,\n'
      'StudyName: $studyName,\n'
      'AppVersion: $appVersion,\n'
      'ClientUuid: $clientUuid';
}
