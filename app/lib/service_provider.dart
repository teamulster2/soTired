import 'package:flutter/cupertino.dart';
import 'package:so_tired/config/config_manager.dart';
import 'package:so_tired/database/database_manager.dart';
import 'package:so_tired/notifications.dart';
import 'package:so_tired/utils.dart';
import 'package:timezone/data/latest.dart' as tz;

/// This class serves as service provider providing a [ConfigManager],
/// [DatabaseManager] and a [Notifications] instance.
class ServiceProvider extends ChangeNotifier {
  final ConfigManager _configManager = ConfigManager();
  final DatabaseManager _databaseManager = DatabaseManager();
  final Notifications _notifications = Notifications();

  ConfigManager get configManager => _configManager;

  DatabaseManager get databaseManager => _databaseManager;

  Notifications get notification => _notifications;

  /// This method initializes [ConfigManager], [DatabaseManager] and
  /// [Notifications] synchronously.
  Future<void> init(Function onDoneInitializing) async {
    // initialize config
    // TODO: Add exception handling for invalid config
    final String filePath =
        await Utils.getLocalFilePath(_configManager.clientConfigFileName);
    if (!Utils.doesFileExist(filePath)) {
      // TODO: invoke configManager.fetchConfigFromServer()
      // or
      _configManager.loadDefaultConfig();
      // ignore: cascade_invocations
      _configManager.writeConfigToFile(_configManager.clientConfig);
    } else {
      _configManager.loadConfigFromJson();
    }

    // initialize database
    await _databaseManager.initDatabase();

    // initialize notifications
    notification.initializeSetting();
    tz.initializeTimeZones();
    await _notifications.showScheduleNotification(
        configManager.clientConfig.notificationInterval,
        configManager.clientConfig.studyName,
        configManager.clientConfig.notificationText);

    onDoneInitializing();
  }
}
