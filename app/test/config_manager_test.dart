import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:so_tired/config/config_manager.dart';
import 'package:so_tired/ui/constants/constants.dart';
import 'package:so_tired/ui/models/questionnaire.dart';
import 'package:so_tired/utils.dart';
import 'package:tuple/tuple.dart';

// ignore_for_file: always_specify_types
// ignore_for_file: cascade_invocations

ConfigManager? _configManager = ConfigManager();

final Map<String, dynamic> defaultAssertObject = <String, dynamic>{
  'serverUrl': 'http://localhost',
  'utcNotificationTimes': <Tuple2<int, int>>[
    // (hour, minutes) use UTC time
    const Tuple2<int, int>(8, 15),
    const Tuple2<int, int>(12, 30),
    const Tuple2<int, int>(15, 00),
  ],
  'notificationText': "Hi, You've been notified! Open the app now!",
  'isSpatialSpanTaskEnabled': true,
  'isMentalArithmeticEnabled': true,
  'isPsychomotorVigilanceTaskEnabled': true,
  'isQuestionnaireEnabled': true,
  'isCurrentActivityEnabled': true,
  'studyName': 'study1',
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
  'notificationInterval': 60 * 3,
  'notificationText': "Hi, You've been notified! Open the app now!",
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

    setUp(() {
      _configManager = null;
      _configManager = ConfigManager();
    });

    test('default config should be available after loading it', () {
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
    // TODO: Add config tests for exception handling
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
