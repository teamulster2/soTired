import 'dart:io';
import 'package:so_tired/ui/constants/constants.dart' as constants;
import 'package:so_tired/config/client_config.dart';
import 'package:so_tired/config/config.dart';
import 'package:so_tired/utils.dart';

/// This class is the main part of configs.
/// It is capable of loading and storing configs from / to json files and also
/// contains the default config.
class ConfigManager {
  static final ConfigManager _configManagerInstance =
      ConfigManager._configManager();
  late final ClientConfig _clientConfig;
  final String _clientConfigFileName = 'client_config.json';

  /// The private constructor ensures that at least one config has been loaded
  /// and is available.
  // TODO: Adjust config load / write methods when implementing settings in STEP III
  ConfigManager._configManager();

  /// [ConfigManager] has been implemented using the *Singleton* design
  /// pattern which ensures that only one config is available throughout the
  /// app.
  factory ConfigManager() => _configManagerInstance;

  ClientConfig get clientConfig => _clientConfig;

  /// This method contains the default config and restores it on demand.
  void loadDefaultConfig() {
    // TODO: Adjust default server url based on the default server config
    // TODO: Specify appropriate notification text
    // TODO: Specify appropriate notification interval format
    // TODO: Specify real study name
    // TODO: Define serious / useful questions
    final ClientConfigBuilder clientConfigBuilder = ClientConfigBuilder()
      ..serverUrl = 'http://localhost'
      ..notificationInterval = 3 * 60 //minutes
      ..notificationText = "Hi, You've been notified! Open the app now!"
      ..isReactionGameEnabled = true
      ..isQuestionnaireEnabled = true
      ..isCurrentActivityEnabled = true
      ..studyName = 'study1'
      ..isStudy = true
      ..questions = constants.questions;

    _clientConfig = clientConfigBuilder.build();
  }

  /// This method loads the config from a existing json file.
  /// It utilizes the [Utils] class.
  Future<void> loadConfigFromJson() async {
    final File configFile =
        await Utils.getConfigFileObject(_clientConfigFileName);
    final String config = await configFile.readAsString();
    final ClientConfigBuilder clientConfigBuilder = ClientConfigBuilder();
    // TODO: Discuss exception handling and adjust this part
    try {
      _clientConfig = clientConfigBuilder.buildWithString(config);
    } catch (e) {
      throw Exception(e);
    }
  }

// TODO: Write doc comments
// TODO: Implement based on server API
// void fetchConfigFromServer() async {
//   _clientConfig = ... json object from server
// }

  /// This method is capable of writing a config to a existing json file.
  /// It takes an instance of type [Config] as argument and uses the
  /// [Config.toJson()] to generate a json object which can be written to a
  /// file.
  Future<void> writeConfigToFile(Config config) async {
    final Map<String, dynamic> json = config.toJson();
    final File configFile =
        await Utils.getConfigFileObject(_clientConfigFileName);
    configFile.writeAsString('$json');
  }
}
