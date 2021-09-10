import 'package:flutter_test/flutter_test.dart';
import 'package:so_tired/service_provider.dart';
import 'package:so_tired/ui/constants/constants.dart' as constants;
import 'package:so_tired/utils.dart';

// ignore_for_file: always_specify_types

ServiceProvider _serviceProvider = ServiceProvider();

final Map<String, dynamic> assertObject = <String, dynamic>{
  'serverUrl': 'http://localhost',
  'notificationInterval': 60 * 3,
  'notificationText': "Hi, You've been notified! Open the app now!",
  'isReactionGameEnabled': true,
  'isQuestionnaireEnabled': true,
  'isCurrentActivityEnabled': true,
  'studyName': 'study1',
  'isStudy': true,
  'questions': constants.questions,
  'moods': <List<int>>[
        <int>[...Utils.stringToCodeUnits('😄')],
        <int>[...Utils.stringToCodeUnits('🤩')],
        <int>[...Utils.stringToCodeUnits('🥱')],
        <int>[...Utils.stringToCodeUnits('😢')]
      ]
};

void main() {
  group('ConfigManager Basics', () {
    // NOTE: This is not working due to issues where `getApplicationDocumentsDirectory` is returning null although it has been mocked following the official docs
    // setUpAll(() async {
    //   // NOTE: This has been copied from https://flutter.dev/docs/cookbook/persistence/reading-writing-files#testing
    //   // Create a temporary directory.
    //   final Directory directory = await Directory.systemTemp.createTemp();
    //
    //   // Mock out the MethodChannel for the path_provider plugin.
    //   const MethodChannel('plugins.flutter.io/path_provider')
    //       .setMockMethodCallHandler((MethodCall methodCall) async {
    //     // If you're getting the apps documents directory, return the path to the
    //     // temp directory on the test environment instead.
    //     if (methodCall.method == 'getApplicationDocumentsDirectory') {
    //       return directory.path;
    //     }
    //     return null;
    //   });
    // });

    _serviceProvider.configManager.loadDefaultConfig();
    test('default config should be available after loading it', () {
      expect(_serviceProvider.configManager.clientConfig.serverUrl,
          assertObject['serverUrl']);
      expect(_serviceProvider.configManager.clientConfig.notificationInterval,
          assertObject['notificationInterval']);
      expect(_serviceProvider.configManager.clientConfig.notificationText,
          assertObject['notificationText']);
      expect(_serviceProvider.configManager.clientConfig.isReactionGameEnabled,
          assertObject['isReactionGameEnabled']);
      expect(_serviceProvider.configManager.clientConfig.isQuestionnaireEnabled,
          assertObject['isQuestionnaireEnabled']);
      expect(
          _serviceProvider.configManager.clientConfig.isCurrentActivityEnabled,
          assertObject['isCurrentActivityEnabled']);
      expect(_serviceProvider.configManager.clientConfig.studyName,
          assertObject['studyName']);
      expect(_serviceProvider.configManager.clientConfig.isStudy,
          assertObject['isStudy']);
      expect(_serviceProvider.configManager.clientConfig.questions,
          assertObject['questions']);
      expect(_serviceProvider.configManager.clientConfig.moods,
          assertObject['moods']);
    });

    // TODO: Add further tests for testing each method in ConfigManager
    // TODO: Add config tests for exception handling
  });
}
