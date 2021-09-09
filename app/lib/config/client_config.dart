import 'dart:convert';

import 'package:so_tired/config/config.dart';
import 'package:so_tired/utils.dart';
import 'package:so_tired/database/models/questionnaire/questionnaire_object.dart';

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

  late final List<QuestionnaireObject> _questions;

  ClientConfig._clientConfig(ClientConfigBuilder clientConfigBuilder) {
    _serverUrl = clientConfigBuilder._serverUrl;
    _notificationInterval = clientConfigBuilder._notificationInterval;
    _notificationText = clientConfigBuilder._notificationText;

    _isReactionGameEnabled = clientConfigBuilder._isReactionGameEnabled;
    _isQuestionnaireEnabled = clientConfigBuilder._isQuestionnaireEnabled;
    _isCurrentActivityEnabled = clientConfigBuilder._isCurrentActivityEnabled;

    _studyName = clientConfigBuilder._studyName;
    _isStudy = clientConfigBuilder._isStudy;

    _questions = clientConfigBuilder._questions;
  }

  get serverUrl => _serverUrl;

  get notificationInterval => _notificationInterval;

  get notificationText => _notificationText;

  get isReactionGameEnabled => _isReactionGameEnabled;

  get isQuestionnaireEnabled => _isQuestionnaireEnabled;

  get isCurrentActivityEnabled => _isCurrentActivityEnabled;

  get studyName => _studyName;

  get isStudy => _isStudy;

  get questions => _questions;

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
        _questions = json['questions'];

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
        'questions': _questions
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

  late final List<QuestionnaireObject> _questions;

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

  set questions(List<QuestionnaireObject> questions) => _questions = questions;

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
    if (!Utils.isClientConfigJsonValid(jsonString)) {
      throw Exception('The client config json is invalid. Make sure '
          'to fix your config and try again.');
    }
    final Map<String, dynamic> clientJson = jsonDecode(jsonString);
    return ClientConfig._fromJson(clientJson);
  }
}
