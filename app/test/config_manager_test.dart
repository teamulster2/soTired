import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:so_tired/config/config_manager.dart';
import 'package:so_tired/ui/constants/constants.dart';
import 'package:so_tired/ui/models/questionnaire.dart';
import 'package:so_tired/utils/utils.dart';

// ignore_for_file: always_specify_types
// ignore_for_file: cascade_invocations

ConfigManager? _configManager = ConfigManager();

final Map<String, dynamic> defaultAssertObject = <String, dynamic>{
  'serverUrl': 'http://localhost:50000/',
  'utcNotificationTimes': <String>[
    // (hour:minutes) use UTC time
    '08:15',
    '12:30',
    '15:00'
  ],
  'notificationText': "Are you 'soTired'? Let's find out!",
  'isSpatialSpanTaskEnabled': true,
  'isMentalArithmeticEnabled': true,
  'isPsychomotorVigilanceTaskEnabled': true,
  'isQuestionnaireEnabled': true,
  'isCurrentActivityEnabled': true,
  'studyName': 'Default Study',
  'isStudy': true,
  'questions': _serializeQuestionnaireObjects(questions),
  'moods': <List<int>>[
    <int>[...Utils.stringToCodeUnits('😄')],
    <int>[...Utils.stringToCodeUnits('🤩')],
    <int>[...Utils.stringToCodeUnits('🥱')],
    <int>[...Utils.stringToCodeUnits('😢')]
  ]
};

final Map<String, dynamic> customAssertObject = <String, dynamic>{
  'serverUrl': 'http://0.0.0.0',
  'utcNotificationTimes': <String>[
    // (hour:minutes) use UTC time
    '08:15',
    '12:30',
    '15:00'
  ],
  'notificationText': "Are you 'soTired'? Let's find out!",
  'isSpatialSpanTaskEnabled': true,
  'isMentalArithmeticEnabled': false,
  'isPsychomotorVigilanceTaskEnabled': true,
  'isQuestionnaireEnabled': true,
  'isCurrentActivityEnabled': false,
  'studyName': 'study2',
  'isStudy': true,
  'questions': _serializeQuestionnaireObjects(questions),
  'moods': <List<int>>[
    <int>[...Utils.stringToCodeUnits('😄')],
    <int>[...Utils.stringToCodeUnits('🤩')],
    <int>[...Utils.stringToCodeUnits('🥱')],
    <int>[...Utils.stringToCodeUnits('😢')]
  ]
};

void main() {
  group('ConfigManager Basics', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      // NOTE: This has been copied from https://flutter.dev/docs/cookbook/persistence/reading-writing-files#testing
      // Create a temporary directory.
      final Directory directory = await Directory.systemTemp.createTemp();

      // Mock out the MethodChannel for the path_provider plugin.
      const MethodChannel('plugins.flutter.io/path_provider')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        // If you're getting the apps documents directory, return the path to the
        // temp directory on the test environment instead.
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return directory.path;
        }
        return null;
      });
    });

    setUp(() async {
      _configManager = null;
      _configManager = ConfigManager();
    });

    test('default config should be available after loading it', () async {
      _configManager!.loadDefaultConfig();
      expect(_configManager!.clientConfig!.toJson(), defaultAssertObject);
    });

    test('should write config to file', () async {
      _configManager!.loadDefaultConfig();
      await _configManager!.writeConfigToFile();
      final File fileObject =
          await Utils.getFileObject(_configManager!.clientConfigFileName);

      expect(jsonDecode(fileObject.readAsStringSync()),
          _configManager!.clientConfig!.toJson());
    });

    test('should load config from file', () async {
      final File fileObject =
          await Utils.getFileObject(_configManager!.clientConfigFileName);
      final String customAssertObjectJson = jsonEncode(customAssertObject);
      await fileObject.writeAsString(customAssertObjectJson);
      await _configManager!.loadConfigFromJson();

      final Map<String, dynamic> fileObjectJson =
          jsonDecode(await fileObject.readAsString());
      expect(fileObjectJson, _configManager!.clientConfig!.toJson());
    });

    // TODO: Test fetchConfigFromServer

    test('empty object should throw exception', () async {
      final File fileObject =
          await Utils.getFileObject(_configManager!.clientConfigFileName);
      await fileObject.writeAsString('');

      throwsA(() async => _configManager!.loadConfigFromJson());
    });

    test('should throw MalformedServerUrlException', () async {
      final File fileObject =
          await Utils.getFileObject(_configManager!.clientConfigFileName);
      customAssertObject['serverUrl'] = 'htt://www.google.de';
      final String customAssertObjectJson = jsonEncode(customAssertObject);
      await fileObject.writeAsString(customAssertObjectJson);

      throwsA(() async => _configManager!.loadConfigFromJson());
    });

    test('should throw MalformedQuestionnaireObjectException', () async {
      final File fileObject =
          await Utils.getFileObject(_configManager!.clientConfigFileName);
      customAssertObject['questions'] = '';
      final String customAssertObjectJson = jsonEncode(customAssertObject);
      await fileObject.writeAsString(customAssertObjectJson);

      throwsA(() async => _configManager!.loadConfigFromJson());
    });

    test('should throw MalformedMoodsException', () async {
      final File fileObject =
          await Utils.getFileObject(_configManager!.clientConfigFileName);
      customAssertObject['moods'] = '';
      final String customAssertObjectJson = jsonEncode(customAssertObject);
      await fileObject.writeAsString(customAssertObjectJson);

      throwsA(() async => _configManager!.loadConfigFromJson());
    });

    test('should throw MalformedUtcNotificationTimesException',
        () async {
      final File fileObject =
          await Utils.getFileObject(_configManager!.clientConfigFileName);
      customAssertObject['utcNotificationTimes'] = <String>['-5:10'];
      final String customAssertObjectJson = jsonEncode(customAssertObject);
      await fileObject.writeAsString(customAssertObjectJson);

      throwsA(() async => _configManager!.loadConfigFromJson());
    });
  });
}

List<Map<String, dynamic>> _serializeQuestionnaireObjects(
    List<QuestionnaireObject> questions) {
  final List<Map<String, dynamic>> questionsJson = <Map<String, dynamic>>[];
  for (final QuestionnaireObject question in questions) {
    questionsJson.add(question.toJson());
  }
  return questionsJson;
}
