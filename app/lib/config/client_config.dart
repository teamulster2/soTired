import 'dart:convert';

import 'package:so_tired/ui/models/questionnaire.dart';

/// A JSON template containing all relevant keys for the client side (app).
class ClientConfig {
  late final String _serverUrl;
  late final int _notificationInterval;
  late final String _notificationText;

  // TODO: extend enabled features / settings in STEP II and STEP III
  late final bool _isSpatialSpanTaskEnabled;
  late final bool _isMentalArithmeticEnabled;
  late final bool _isPsychomotorVigilanceTaskEnabled;
  late final bool _isQuestionnaireEnabled;
  late final bool _isCurrentActivityEnabled;

  late final String _studyName;
  late final bool _isStudy;

  late final List<QuestionnaireObject> _questions;

  late final List<List<int>> _moods;

  ClientConfig._clientConfig(ClientConfigBuilder clientConfigBuilder) {
    _serverUrl = clientConfigBuilder._serverUrl;
    _notificationInterval = clientConfigBuilder._notificationInterval;
    _notificationText = clientConfigBuilder._notificationText;

    _isSpatialSpanTaskEnabled = clientConfigBuilder._isSpatialSpanTaskEnabled;
    _isMentalArithmeticEnabled = clientConfigBuilder._isMentalArithmeticEnabled;
    _isPsychomotorVigilanceTaskEnabled =
        clientConfigBuilder._isPsychomotorVigilanceTaskEnabled;
    _isQuestionnaireEnabled = clientConfigBuilder._isQuestionnaireEnabled;
    _isCurrentActivityEnabled = clientConfigBuilder._isCurrentActivityEnabled;

    _studyName = clientConfigBuilder._studyName;
    _isStudy = clientConfigBuilder._isStudy;

    _questions = clientConfigBuilder._questions;

    _moods = clientConfigBuilder._moods;
  }

  get serverUrl => _serverUrl;

  get notificationInterval => _notificationInterval;

  get notificationText => _notificationText;

  get isReactionGameEnabled => _isSpatialSpanTaskEnabled;

  get isMentalArithmeticEnabled => _isMentalArithmeticEnabled;

  get isPsychomotorVigilanceTaskEnabled => _isPsychomotorVigilanceTaskEnabled;

  get isQuestionnaireEnabled => _isQuestionnaireEnabled;

  get isCurrentActivityEnabled => _isCurrentActivityEnabled;

  get studyName => _studyName;

  get isStudy => _isStudy;

  get questions => _questions;

  get moods => _moods;

  /// A private constructor which takes a [Map<String, dynamic> json] and
  /// assigns all keys to their counterpart.
  ClientConfig._fromJson(Map<String, dynamic> json)
      : _serverUrl = json['serverUrl'],
        _notificationInterval = json['notificationInterval'],
        _notificationText = json['notificationText'],
        _isSpatialSpanTaskEnabled = json['isSpatialSpanTaskEnabled'],
        _isMentalArithmeticEnabled = json['isMentalArithmeticEnabled'],
        _isPsychomotorVigilanceTaskEnabled =
            json['isPsychomotorVigilanceTaskEnabled'],
        _isQuestionnaireEnabled = json['isQuestionnaireEnabled'],
        _isCurrentActivityEnabled = json['isCurrentActivityEnabled'],
        _studyName = json['studyName'],
        _isStudy = json['isStudy'],
        _questions = json['questions'],
        _moods = json['moods'];

  /// This method takes all JSON keys from this class and converts them into a
  /// JSON object represented as [Map<String, dynamic>].
  Map<String, dynamic> toJson() => <String, dynamic>{
        'serverUrl': _serverUrl,
        'notificationInterval': _notificationInterval,
        'notificationText': _notificationText,
        'isSpatialSpanTaskEnabled': _isSpatialSpanTaskEnabled,
        'isMentalArithmeticEnabled': _isMentalArithmeticEnabled,
        'isPsychomotorVigilanceTaskEnabled': _isPsychomotorVigilanceTaskEnabled,
        'isQuestionnaireEnabled': _isQuestionnaireEnabled,
        'isCurrentActivityEnabled': _isCurrentActivityEnabled,
        'studyName': _studyName,
        'isStudy': _isStudy,
        'questions': _questions,
        'moods': _moods
      };
}

/// This class serves as Builder class for [ClientConfig].
class ClientConfigBuilder {
  late final String _serverUrl;
  late final int _notificationInterval;
  late final String _notificationText;

  // TODO: extend enabled features / settings in STEP II and STEP III
  late final bool _isSpatialSpanTaskEnabled;
  late final bool _isMentalArithmeticEnabled;
  late final bool _isPsychomotorVigilanceTaskEnabled;
  late final bool _isQuestionnaireEnabled;
  late final bool _isCurrentActivityEnabled;

  late final String _studyName;
  late final bool _isStudy;

  late final List<QuestionnaireObject> _questions;

  late final List<List<int>> _moods;

  ClientConfigBuilder();

  set serverUrl(String url) => _serverUrl = url;

  set notificationInterval(int interval) => _notificationInterval = interval;

  set notificationText(String text) => _notificationText = text;

  set isSpatialSpanTaskEnabled(bool isSpatialSpanTaskEnabled) =>
      _isSpatialSpanTaskEnabled = isSpatialSpanTaskEnabled;

  set isPsychomotorVigilanceTaskEnabled(
          bool isPsychomotorVigilanceTaskEnabled) =>
      _isPsychomotorVigilanceTaskEnabled = isPsychomotorVigilanceTaskEnabled;

  set isMentalArithmeticEnabled(bool isMentalArithmeticEnabled) =>
      _isMentalArithmeticEnabled = isMentalArithmeticEnabled;

  set isQuestionnaireEnabled(bool isQuestionnaireEnabled) =>
      _isQuestionnaireEnabled = isQuestionnaireEnabled;

  set isCurrentActivityEnabled(bool isCurrentActivityEnabled) =>
      _isCurrentActivityEnabled = isCurrentActivityEnabled;

  set studyName(String studyName) => _studyName = studyName;

  set isStudy(bool isStudy) => _isStudy = isStudy;

  set questions(List<QuestionnaireObject> questions) => _questions = questions;

  set moods(List<List<int>> moods) => _moods = moods;

  /// Build a [ClientConfig] instance after specifying all mandatory keys
  /// manually.
  ClientConfig build() {
    ClientConfig clientConfig;
    try {
      clientConfig = ClientConfig._clientConfig(this);
    } catch (e) {
      // TODO: add customized exception
      throw Exception('A new ClientConfig instance can not be created.\n\n$e');
    }
    return clientConfig;
  }

  /// Build a [ClientConfig] instance by passing a [String]
  /// containing valid JSON, e.g. taken from a json file.
  ClientConfig buildWithString(String jsonString) {
    if (!_isClientConfigJsonValid(jsonString)) {
      // TODO: add customized exception
      throw Exception('The client config json is invalid. Make sure '
          'to fix your config and try again.');
    }
    final Map<String, dynamic> clientJson = jsonDecode(jsonString);
    return ClientConfig._fromJson(clientJson);
  }

  /// This method takes a [String] and checks its
  /// compatibility to the [ClientConfig] class.
  bool _isClientConfigJsonValid(String clientConfigJsonString) {
    late final Map<String, dynamic> jsonResponse;
    try {
      jsonResponse = jsonDecode(clientConfigJsonString);
    } catch (e) {
      return false;
    }

    // TODO: check specific keys when they're defined, e.g. is URL valid, ...
    return jsonResponse.containsKey('serverUrl') &&
        jsonResponse.containsKey('notificationInterval') &&
        jsonResponse.containsKey('notificationText') &&
        jsonResponse.containsKey('isSpatialSpanTaskEnabled') &&
        jsonResponse.containsKey('isMentalArithmeticEnabled') &&
        jsonResponse.containsKey('isPsychomotorVigilanceTaskEnabled') &&
        jsonResponse.containsKey('isQuestionnaireEnabled') &&
        jsonResponse.containsKey('isCurrentActivityEnabled') &&
        jsonResponse.containsKey('studyName') &&
        jsonResponse.containsKey('isStudy') &&
        jsonResponse.containsKey('questions') &&
        jsonResponse.containsKey('moods');
  }
}
