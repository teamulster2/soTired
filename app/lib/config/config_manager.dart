
import 'package:so_tired/config/client_config.dart';
import 'package:so_tired/config/config.dart';
import 'package:so_tired/config/config_utils.dart';

class ConfigManager {
  static final ConfigManager _configManagerInstance =
      ConfigManager._configManager();
  late final ClientConfig _clientConfig;
  final String _clientConfigFileName = 'client_config.json';

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

  factory ConfigManager() => _configManagerInstance;

  ClientConfig get clientConfig => _clientConfig;

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

// TODO: Implement based on server API
// void fetchConfigFromServer() async {
//   _clientConfig = ... json object from server
// }

  void _writeConfigToFile(Config config) async {
    final Map<String, dynamic> json = config.toJson();
    final configFile =
        await ConfigUtils.getConfigFileObject(_clientConfigFileName);
    configFile.writeAsString('$json');
  }
}
