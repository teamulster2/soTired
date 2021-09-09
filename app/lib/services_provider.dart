import 'package:flutter/cupertino.dart';
import 'package:so_tired/config/config_manager.dart';
import 'package:so_tired/database/database_manager.dart';
import 'package:so_tired/utils.dart';

class ServicesProvider extends ChangeNotifier {
  final ConfigManager _configManager = ConfigManager();
  final DatabaseManager _databaseManager = DatabaseManager();

  ConfigManager get configManager => _configManager;

  DatabaseManager get databaseManager => _databaseManager;

  Future<void> init(Function onDoneInitializing) async {
    // _configManager.loadDefaultConfig();
    // TODO: Use this to initialize config
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

    await _databaseManager.initDatabase();
    onDoneInitializing();
  }
}
