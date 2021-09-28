import 'dart:convert';

import 'package:so_tired/exceptions/exceptions.dart';
import 'package:so_tired/ui/models/questionnaire.dart';

/// A JSON template containing all relevant keys for the client side (app).
class ClientConfig {
  late final List<String> _utcNotificationTimes;
  late final String _notificationText;

  late final bool _isSpatialSpanTaskEnabled;
  late final bool _isPsychomotorVigilanceTaskEnabled;
  late final bool _isQuestionnaireEnabled;
  late final bool _isCurrentActivityEnabled;

  late final String _studyName;
  late final bool _isStudy;

  late final List<QuestionnaireObject> _questions;

  ClientConfig._clientConfig(ClientConfigBuilder clientConfigBuilder) {
    _utcNotificationTimes = clientConfigBuilder._utcNotificationTimes;
    _notificationText = clientConfigBuilder._notificationText;

    _isSpatialSpanTaskEnabled = clientConfigBuilder._isSpatialSpanTaskEnabled;
    _isPsychomotorVigilanceTaskEnabled =
        clientConfigBuilder._isPsychomotorVigilanceTaskEnabled;
    _isQuestionnaireEnabled = clientConfigBuilder._isQuestionnaireEnabled;
    _isCurrentActivityEnabled = clientConfigBuilder._isCurrentActivityEnabled;

    _studyName = clientConfigBuilder._studyName;
    _isStudy = clientConfigBuilder._isStudy;

    _questions = clientConfigBuilder._questions;
  }

  get utcNotificationTimes => _utcNotificationTimes;

  get notificationText => _notificationText;

  get isSpatialSpanTaskEnabled => _isSpatialSpanTaskEnabled;

  get isPsychomotorVigilanceTaskEnabled => _isPsychomotorVigilanceTaskEnabled;

  get isQuestionnaireEnabled => _isQuestionnaireEnabled;

  get isCurrentActivityEnabled => _isCurrentActivityEnabled;

  get studyName => _studyName;

  get isStudy => _isStudy;

  get questions => _questions;

  /// A private constructor which takes a [Map<String, dynamic> json] and
  /// assigns all keys to their counterpart.
  ClientConfig._fromJson(Map<String, dynamic> json)
      : _utcNotificationTimes = json['utcNotificationTimes'],
        _notificationText = json['notificationText'],
        _isSpatialSpanTaskEnabled = json['isSpatialSpanTaskEnabled'],
        _isPsychomotorVigilanceTaskEnabled =
            json['isPsychomotorVigilanceTaskEnabled'],
        _isQuestionnaireEnabled = json['isQuestionnaireEnabled'],
        _isCurrentActivityEnabled = json['isCurrentActivityEnabled'],
        _studyName = json['studyName'],
        _isStudy = json['isStudy'],
        _questions = json['questions'];

  /// This method takes all JSON keys from this class and converts them into a
  /// JSON object represented as [Map<String, dynamic>].
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> returnMap = <String, dynamic>{
      'utcNotificationTimes': _utcNotificationTimes,
      'notificationText': _notificationText,
      'isSpatialSpanTaskEnabled': _isSpatialSpanTaskEnabled,
      'isPsychomotorVigilanceTaskEnabled': _isPsychomotorVigilanceTaskEnabled,
      'isQuestionnaireEnabled': _isQuestionnaireEnabled,
      'isCurrentActivityEnabled': _isCurrentActivityEnabled,
      'studyName': _studyName,
      'isStudy': _isStudy,
      'questions': _questions
    };
    returnMap['questions'] =
        ClientConfigBuilder._serializeQuestionnaireObjects(_questions);

    return returnMap;
  }
}

/// This class serves as Builder class for [ClientConfig].
class ClientConfigBuilder {
  late final List<String> _utcNotificationTimes;
  late final String _notificationText;

  late final bool _isSpatialSpanTaskEnabled;
  late final bool _isPsychomotorVigilanceTaskEnabled;
  late final bool _isQuestionnaireEnabled;
  late final bool _isCurrentActivityEnabled;

  late final String _studyName;
  late final bool _isStudy;

  late final List<QuestionnaireObject> _questions;

  ClientConfigBuilder();

  set utcNotificationTimes(List<String> notificationTimes) =>
      _utcNotificationTimes = notificationTimes;

  set notificationText(String text) => _notificationText = text;

  set isSpatialSpanTaskEnabled(bool isSpatialSpanTaskEnabled) =>
      _isSpatialSpanTaskEnabled = isSpatialSpanTaskEnabled;

  set isPsychomotorVigilanceTaskEnabled(
          bool isPsychomotorVigilanceTaskEnabled) =>
      _isPsychomotorVigilanceTaskEnabled = isPsychomotorVigilanceTaskEnabled;

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
    ClientConfig clientConfig;
    try {
      clientConfig = ClientConfig._clientConfig(this);
    } catch (e) {
      throw ClientConfigNotInitializedException(
          'A new ClientConfig instance can not be created.\n\n'
          'Initial error message:\n$e');
    }
    return clientConfig;
  }

  /// Build a [ClientConfig] instance by passing a [String]
  /// containing valid JSON, e.g. taken from a json file.
  ClientConfig buildWithString(String jsonString) {
    late final Map<String, dynamic> clientJson;
    try {
      _isClientConfigJsonValid(jsonString);

      clientJson = jsonDecode(jsonString);
      clientJson['utcNotificationTimes'] =
          _deserializeUtcNotificationTimes(clientJson);
      clientJson['questions'] = _deserializeQuestionnaireObjects(clientJson);
    } catch (e) {
      rethrow;
    }

    return ClientConfig._fromJson(clientJson);
  }

  /// This method takes a [String] and checks its
  /// compatibility to the [ClientConfig] class.
  void _isClientConfigJsonValid(String clientConfigJsonString) {
    late final Map<String, dynamic> jsonResponse;
    try {
      jsonResponse = jsonDecode(clientConfigJsonString);
    } catch (e) {
      throw MalformedJsonException(
          'Your json string cannot be converted into a object. '
          'Make sure it is properly formatted!\n\n'
          'Initial error message:\n$e');
    }

    try {
      jsonResponse.containsKey('utcNotificationTimes') &&
          jsonResponse.containsKey('notificationText') &&
          jsonResponse.containsKey('isSpatialSpanTaskEnabled') &&
          jsonResponse.containsKey('isPsychomotorVigilanceTaskEnabled') &&
          jsonResponse.containsKey('isQuestionnaireEnabled') &&
          jsonResponse.containsKey('isCurrentActivityEnabled') &&
          jsonResponse.containsKey('studyName') &&
          jsonResponse.containsKey('isStudy') &&
          jsonResponse.containsKey('questions');
    } catch (e) {
      throw MalformedJsonException(
          'The jsonResponse does not contain all necessary keys to '
          'instantiate a new client config.\n\n'
          'Initial error message:\n$e');
    }

    try {
      jsonResponse['questions'] =
          _deserializeQuestionnaireObjects(jsonResponse);
    } catch (e) {
      throw MalformedQuestionnaireObjectException(
          'QuestionnaireObjects have not been deserialized properly. '
          'Make sure to identify the List type or invoke '
          '_deserializeQuestionnaireObjects!\n\n'
          '$jsonResponse\n\n'
          'Initial error message:\n$e');
    }

    try {
      jsonResponse['utcNotificationTimes'] =
          _deserializeUtcNotificationTimes(jsonResponse);
    } catch (e) {
      throw MalformedUtcNotificationTimesException(
          'utcNotificationTimes have not been deserialized properly. '
          'Make sure to identify the List type or invoke '
          '_deserializeUtcNotificationTimes!\n\n'
          '$jsonResponse\n\n'
          'Initial error message:\n$e');
    }

    for (final String time in jsonResponse['utcNotificationTimes']) {
      if (time.length != 5 ||
          !time.contains(':') && !(time.indexOf(':') == 2) ||
          int.parse(time.substring(0, 2), radix: 10) > 23 ||
          int.parse(time.substring(3, 5), radix: 10) > 59 ||
          int.parse(time.substring(0, 2), radix: 10) < 0 ||
          int.parse(time.substring(3, 5), radix: 10) < 0) {
        throw MalformedUtcNotificationTimesException(
            'This notification time format is invalid and can not be processed.\n'
            'Current time variable: $time');
      }
    }
  }

  /// This method is used to convert [QuestionnaireObject]s from object to JSON.
  static List<Map<String, dynamic>> _serializeQuestionnaireObjects(
      List<QuestionnaireObject> questions) {
    final List<Map<String, dynamic>> questionsJson = <Map<String, dynamic>>[];
    for (final QuestionnaireObject question in questions) {
      questionsJson.add(question.toJson());
    }
    return questionsJson;
  }

  /// This method is used to convert [QuestionnaireObject]s from JSON to object.
  static List<QuestionnaireObject> _deserializeQuestionnaireObjects(
      Map<String, dynamic> json) {
    final List<QuestionnaireObject> questions = <QuestionnaireObject>[];
    final List<Map<String, dynamic>> questionsJson =
        List<Map<String, dynamic>>.from(json['questions']);
    for (final Map<String, dynamic> question in questionsJson) {
      final Map<String, dynamic> addition = <String, dynamic>{
        'question': question['question'],
        'answers': List<String>.from(question['answers'])
      };
      questions.add(QuestionnaireObject.fromJson(addition));
    }
    return questions;
  }

  /// This method is used to convert notificationTimes from JSON to [List]
  /// of type [String].
  static List<String> _deserializeUtcNotificationTimes(
          Map<String, dynamic> json) =>
      List<String>.from(json['utcNotificationTimes']);
}
