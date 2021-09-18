import 'dart:convert';
import 'dart:io';

import 'package:so_tired/config/client_config.dart';
import 'package:so_tired/exceptions/exceptions.dart';
import 'package:so_tired/ui/constants/constants.dart';
import 'package:so_tired/utils/utils.dart';
import 'package:so_tired/api/client.dart';

/// This class is the main part of configs.
/// It is capable of loading and storing configs from / to json files and also
/// contains the default config.
class ConfigManager {
  static final ConfigManager _configManagerInstance =
      ConfigManager._configManager();
  final String _clientConfigFileName = 'client_config.json';
  ClientConfig? _clientConfig;

  /// The private constructor enables the class to create only one instance of
  /// itself.
  ConfigManager._configManager() {
    loadDefaultConfig();
    writeConfigToFile();
  }

  /// [ConfigManager] has been implemented using the *Singleton* design
  /// pattern which ensures that only one config is available throughout the
  /// app.
  factory ConfigManager() => _configManagerInstance;

  ClientConfig? get clientConfig => _clientConfig;

  String get clientConfigFileName => _clientConfigFileName;

  /// This method contains the default config and restores it on demand.
  void loadDefaultConfig() {
    final ClientConfigBuilder clientConfigBuilder = ClientConfigBuilder()
      ..serverUrl = 'http://localhost:50000/'
      ..utcNotificationTimes = <String>[
        // (hour:minutes) use UTC time
        '08:15',
        '12:30',
        '15:00'
      ]
      ..notificationText = "Are you 'soTired'? Let's find out!"
      ..isSpatialSpanTaskEnabled = true
      ..isMentalArithmeticEnabled = true
      ..isPsychomotorVigilanceTaskEnabled = true
      ..isQuestionnaireEnabled = true
      ..isCurrentActivityEnabled = true
      ..studyName = 'Default Study'
      ..isStudy = true
      ..questions = questions;

    _clientConfig = clientConfigBuilder.build();
  }

  /// This method loads the config from a existing json file.
  /// It utilizes the [Utils] class.
  Future<void> loadConfigFromJson() async {
    final File configFile = await Utils.getFileObject(_clientConfigFileName);
    final String config = await configFile.readAsString();
    final ClientConfigBuilder clientConfigBuilder = ClientConfigBuilder();
    try {
      _clientConfig = clientConfigBuilder.buildWithString(config);
    } catch (e) {
      rethrow;
    }
  }

  /// This method loads the config from a server, and write it to [_clientConfig].
  Future<void> fetchConfigFromServer(String url) async {
    try{
      final String configString = await loadConfig(url);

      final ClientConfigBuilder clientConfigBuilder = ClientConfigBuilder();
      final ClientConfig configJson =
      clientConfigBuilder.buildWithString(configString);
      _clientConfig = configJson;
    }catch(e){
      rethrow;
    }

  }

  /// This method is capable of writing a config to an existing JSON file.
  /// It takes an instance of type [ClientConfig] as argument and uses the
  /// [Config.toJson()] to generate a json object which can be written to a
  /// file.
  Future<void> writeConfigToFile() async {
    String json = '';
    try {
      json = jsonEncode(_clientConfig!.toJson());
    } catch (e) {
      throw ClientConfigNotInitializedException(
          'There is something wrong with your client config instance. '
          'Make sure it has been properly initialized!\n\n'
          'Initial error message:\n$e');
    }
    final File configFile = await Utils.getFileObject(_clientConfigFileName);
    await configFile.writeAsString(json);
  }
}
