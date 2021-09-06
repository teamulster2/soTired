import 'dart:convert';

import 'package:so_tired/config/config.dart';
import 'package:so_tired/config/config_utils.dart';

/// A JSON template containing all relevant keys for the client side (app).
class ClientConfig implements Config {
  late final String _serverUrl;
  late final int _notificationInterval;
  late final String _notificationText;

  // TODO: extend enabled features / settings in STEP II and STEP III
  late final bool _isReactionGameEnabled;
  late final bool _isQuestionnaireEnabled;
  late final bool _isCurrentActivityEnabled;

  late final String _studyName;
  late final bool _isStudy;

  // TODO: extend based on real questions
  // TODO: adjust variable names of questions based on real questions
  late final String _question1;
  late final String _question2;
  late final String _question3;
  late final String _question4;
  late final String _question5;

  ClientConfig._clientConfig(ClientConfigBuilder clientConfigBuilder) {
    _serverUrl = clientConfigBuilder._serverUrl;
    _notificationInterval = clientConfigBuilder._notificationInterval;
    _notificationText = clientConfigBuilder._notificationText;

    _isReactionGameEnabled = clientConfigBuilder._isReactionGameEnabled;
    _isQuestionnaireEnabled = clientConfigBuilder._isQuestionnaireEnabled;
    _isCurrentActivityEnabled = clientConfigBuilder._isCurrentActivityEnabled;

    _studyName = clientConfigBuilder._studyName;
    _isStudy = clientConfigBuilder._isStudy;

    _question1 = clientConfigBuilder._question1;
    _question2 = clientConfigBuilder._question2;
    _question3 = clientConfigBuilder._question3;
    _question4 = clientConfigBuilder._question4;
    _question5 = clientConfigBuilder._question5;
  }

  get serverUrl => _serverUrl;

  get notificationInterval => _notificationInterval;

  get notificationText => _notificationText;

  get isReactionGameEnabled => _isReactionGameEnabled;

  get isQuestionnaireEnabled => _isQuestionnaireEnabled;

  get isCurrentActivityEnabled => _isCurrentActivityEnabled;

  get studyName => _studyName;

  get isStudy => _isStudy;

  get question1 => _question1;

  get question2 => _question2;

  get question3 => _question3;

  get question4 => _question4;

  get question5 => _question5;

  /// A private constructor which takes a [Map<String, dynamic> json] and
  /// assigns all keys to their counterpart.
  ClientConfig._fromJson(Map<String, dynamic> json)
      : _serverUrl = json['serverUrl'],
        _notificationInterval = json['notificationInterval'],
        _notificationText = json['notificationText'],
        _isReactionGameEnabled = json['isReactionGameEnabled'],
        _isQuestionnaireEnabled = json['isQuestionnaireEnabled'],
        _isCurrentActivityEnabled = json['isCurrentActivityEnabled'],
        _studyName = json['studyName'],
        _isStudy = json['isStudy'],
        _question1 = json['question1'],
        _question2 = json['question2'],
        _question3 = json['question3'],
        _question4 = json['question4'],
        _question5 = json['question5'];

  /// This method takes all JSON keys from this class and converts them into a
  /// JSON object represented as [Map<String, dynamic>].
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'serverUrl': _serverUrl,
        'notificationInterval': _notificationInterval,
        'notificationText': _notificationText,
        'isReactionGameEnabled': _isReactionGameEnabled,
        'isQuestionnaireEnabled': _isQuestionnaireEnabled,
        'isCurrentActivityEnabled': _isCurrentActivityEnabled,
        'studyName': _studyName,
        'isStudy': _isStudy,
        'question1': _question1,
        'question2': _question2,
        'question3': _question3,
        'question4': _question4,
        'question5': _question5
      };
}

/// This class serves as Builder class for [ClientConfig].
class ClientConfigBuilder {
  late final String _serverUrl;
  late final int _notificationInterval;
  late final String _notificationText;

  // TODO: extend enabled features / settings in STEP II and STEP III
  late final bool _isReactionGameEnabled;
  late final bool _isQuestionnaireEnabled;
  late final bool _isCurrentActivityEnabled;

  late final String _studyName;
  late final bool _isStudy;

  // TODO: extend based on real questions
  // TODO: adjust variable names of questions based on real questions
  late final String _question1;
  late final String _question2;
  late final String _question3;
  late final String _question4;
  late final String _question5;

  ClientConfigBuilder();

  set serverUrl(String url) => _serverUrl = url;

  set notificationInterval(int interval) => _notificationInterval = interval;

  set notificationText(String text) => _notificationText = text;

  set isReactionGameEnabled(bool isReactionGameEnabled) =>
      _isReactionGameEnabled = isReactionGameEnabled;

  set isQuestionnaireEnabled(bool isQuestionnaireEnabled) =>
      _isQuestionnaireEnabled = isQuestionnaireEnabled;

  set isCurrentActivityEnabled(bool isCurrentActivityEnabled) =>
      _isCurrentActivityEnabled = isCurrentActivityEnabled;

  set studyName(String studyName) => _studyName = studyName;

  set isStudy(bool isStudy) => _isStudy = isStudy;

  set question1(String question1) => _question1 = question1;

  set question2(String question2) => _question2 = question2;

  set question3(String question3) => _question3 = question3;

  set question4(String question4) => _question4 = question4;

  set question5(String question5) => _question5 = question5;

  /// Build a [ClientConfig] instance after specifying all mandatory keys
  /// manually.
  ClientConfig build() {
    // TODO: Discuss exception handling and adjust this part
    // TODO: Check whether or not method in ConfigUtils could be a better fit
    ClientConfig clientConfig;
    try {
      clientConfig = ClientConfig._clientConfig(this);
    } catch (e) {
      throw Exception('A new ClientConfig instance can not be created.\n\n$e');
    }
    return clientConfig;
  }

  /// Build a [ClientConfig] instance by passing a [String jsonString]
  /// containing valid JSON, e.g. taken from a json file.
  ClientConfig buildWithString(String jsonString) {
    if (!ConfigUtils.isClientConfigJsonValid(jsonString)) {
      throw Exception('The client config json is invalid. Make sure '
          'to fix your config and try again.');
    }
    final Map<String, dynamic> clientJson = jsonDecode(jsonString);
    return ClientConfig._fromJson(clientJson);
  }
}
