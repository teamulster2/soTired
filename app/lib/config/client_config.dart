import 'dart:convert';

import 'package:so_tired/config/config.dart';

import 'config_utils.dart';

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
    this._serverUrl = clientConfigBuilder._serverUrl;
    this._notificationInterval = clientConfigBuilder._notificationInterval;
    this._notificationText = clientConfigBuilder._notificationText;

    this._isReactionGameEnabled = clientConfigBuilder._isReactionGameEnabled;
    this._isQuestionnaireEnabled = clientConfigBuilder._isQuestionnaireEnabled;
    this._isCurrentActivityEnabled =
        clientConfigBuilder._isCurrentActivityEnabled;

    this._studyName = clientConfigBuilder._studyName;
    this._isStudy = clientConfigBuilder._isStudy;

    this._question1 = clientConfigBuilder._question1;
    this._question2 = clientConfigBuilder._question2;
    this._question3 = clientConfigBuilder._question3;
    this._question4 = clientConfigBuilder._question4;
    this._question5 = clientConfigBuilder._question5;
  }

  get serverUrl => this._serverUrl;

  get notificationInterval => this._notificationInterval;

  get notificationText => this._notificationText;

  get isReactionGameEnabled => this._isReactionGameEnabled;

  get isQuestionnaireEnabled => this._isQuestionnaireEnabled;

  get isCurrentActivityEnabled => this._isCurrentActivityEnabled;

  get studyName => this._studyName;

  get isStudy => this._isStudy;

  get question1 => this._question1;

  get question2 => this._question2;

  get question3 => this._question3;

  get question4 => this._question4;

  get question5 => this._question5;

  /// A private constructor which takes a [Map<String, dynamic> json] and
  /// assigns all keys to their counterpart.
  ClientConfig._fromJson(Map<String, dynamic> json)
      : this._serverUrl = json['serverUrl'],
        this._notificationInterval = json['notificationInterval'],
        this._notificationText = json['notificationText'],
        this._isReactionGameEnabled = json['isReactionGameEnabled'],
        this._isQuestionnaireEnabled = json['isQuestionnaireEnabled'],
        this._isCurrentActivityEnabled = json['isCurrentActivityEnabled'],
        this._studyName = json['studyName'],
        this._isStudy = json['isStudy'],
        this._question1 = json['question1'],
        this._question2 = json['question2'],
        this._question3 = json['question3'],
        this._question4 = json['question4'],
        this._question5 = json['question5'];

  /// This method takes all JSON keys from this class and converts them into a
  /// JSON object represented as [Map<String, dynamic>].
  Map<String, dynamic> toJson() => {
        'serverUrl': this._serverUrl,
        'notificationInterval': this._notificationInterval,
        'notificationText': this._notificationText,
        'isReactionGameEnabled': this._isReactionGameEnabled,
        'isQuestionnaireEnabled': this._isQuestionnaireEnabled,
        'isCurrentActivityEnabled': this._isCurrentActivityEnabled,
        'studyName': this._studyName,
        'isStudy': this._isStudy,
        'question1': this._question1,
        'question2': this._question2,
        'question3': this._question3,
        'question4': this._question4,
        'question5': this._question5
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

  set serverUrl(String url) => this._serverUrl = url;

  set notificationInterval(int interval) =>
      this._notificationInterval = interval;

  set notificationText(String text) => this._notificationText = text;

  set isReactionGameEnabled(bool isReactionGameEnabled) =>
      this._isReactionGameEnabled = isReactionGameEnabled;

  set isQuestionnaireEnabled(bool isQuestionnaireEnabled) =>
      this._isQuestionnaireEnabled = isQuestionnaireEnabled;

  set isCurrentActivityEnabled(bool isCurrentActivityEnabled) =>
      this._isCurrentActivityEnabled = isCurrentActivityEnabled;

  set studyName(String studyName) => this._studyName = studyName;

  set isStudy(bool isStudy) => this._isStudy = isStudy;

  set question1(String question1) => this._question1 = question1;

  set question2(String question2) => this._question2 = question2;

  set question3(String question3) => this._question3 = question3;

  set question4(String question4) => this._question4 = question4;

  set question5(String question5) => this._question5 = question5;

  /// Build a [ClientConfig] instance after specifying all mandatory keys
  /// manually.
  ClientConfig build() {
    // TODO: Discuss exception handling and adjust this part
    // TODO: Check whether or not method in ConfigUtils could be a better fit
    ClientConfig clientConfig;
    try {
      clientConfig = new ClientConfig._clientConfig(this);
    } catch (e) {
      throw new Exception(
          'A new ClientConfig instance can not be created.\n\n$e');
    }
    return clientConfig;
  }

  /// Build a [ClientConfig] instance by passing a [String jsonString]
  /// containing valid JSON, e.g. taken from a json file.
  ClientConfig buildWithString(String jsonString) {
    if (!ConfigUtils.isClientConfigJsonValid(jsonString)) {
      throw new Exception('The client config json is invalid. Make sure'
          'to fix your config and try again.');
    }
    final Map<String, dynamic> clientJson = jsonDecode(jsonString);
    return new ClientConfig._fromJson(clientJson);
  }
}
