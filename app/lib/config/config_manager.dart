import 'package:so_tired/config/client_config.dart';
import 'package:so_tired/config/config.dart';
import 'package:so_tired/config/config_utils.dart';

/// This class is the main part of configs.
/// It is capable of loading and storing configs from / to json files and also
/// contains the default config.
class ConfigManager {
  static final ConfigManager _configManagerInstance =
      ConfigManager._configManager();
  late final ClientConfig _clientConfig;
  final String _clientConfigFileName = 'client_config.json';

  /// Its private constructor ensures that at least one config has been loaded
  /// and is available.
  ConfigManager._configManager() {
    // TODO: Discuss exception handling and adjust this part
    // NOTE: default config will always be loaded - it might be helpful to adjust this in a more efficient way

    ConfigUtils.getLocalFilePath(_clientConfigFileName).then((value) {
      if (!ConfigUtils.doesFileExist(value)) {
        // TODO: invoke _fetchConfigFromServer()
        // or
        _loadDefaultConfig();
        _writeConfigToFile(_clientConfig);
      } else {
        _loadConfigFromJson();
      }
    });
  }

  /// [ConfigManager] has been implemented using the *Singleton* design
  /// pattern which ensures that only one config is available throughout the
  /// app.
  factory ConfigManager() => _configManagerInstance;

  ClientConfig get clientConfig => _clientConfig;

  /// This method contains the default config and restores it on demand.
  void _loadDefaultConfig() {
    final clientConfigBuilder = ClientConfigBuilder();

    // TODO: Adjust default server url based on the default server config
    clientConfigBuilder.serverUrl = 'http://localhost';
    // TODO: Specify appropriate notification interval format
    clientConfigBuilder.notificationInterval = 60 * 60 * 3;
    // TODO: Specify appropriate notification text
    clientConfigBuilder.notificationText =
        'Hi, You\'ve been notified! Open the app now!';

    clientConfigBuilder.isReactionGameEnabled = true;
    clientConfigBuilder.isQuestionnaireEnabled = true;
    clientConfigBuilder.isCurrentActivityEnabled = true;

    // TODO: Specify real study name
    clientConfigBuilder.studyName = 'study1';
    clientConfigBuilder.isStudy = true;

    // TODO: Define serious / useful questions
    clientConfigBuilder.question1 = 'How are you?';
    clientConfigBuilder.question2 = 'How\'s your dog doing?';
    clientConfigBuilder.question3 = 'Can you tell me a couple more questions?';
    clientConfigBuilder.question4 = 'Can you read?';
    clientConfigBuilder.question5 = 'Why am I here? lol';

    _clientConfig = clientConfigBuilder.build();
  }

  /// This method loads the config from a existing json file.
  /// It utilizes the [ConfigUtils] class.
  void _loadConfigFromJson() async {
    final configFile =
        await ConfigUtils.getConfigFileObject(_clientConfigFileName);
    final config = await configFile.readAsString();
    final clientConfigBuilder = ClientConfigBuilder();
    try {
      _clientConfig = clientConfigBuilder.buildWithString(config);
    } catch (e) {
      throw new Exception(e);
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
  void _writeConfigToFile(Config config) async {
    final Map<String, dynamic> json = config.toJson();
    final configFile =
        await ConfigUtils.getConfigFileObject(_clientConfigFileName);
    configFile.writeAsString('$json');
  }
}
