import 'package:flutter_test/flutter_test.dart';
import 'package:so_tired/services_provider.dart';

// ignore_for_file: always_specify_types

ServicesProvider _servicesProvider = ServicesProvider();

final Map<String, dynamic> assertObject = <String, dynamic>{
  'serverUrl': 'http://localhost',
  'notificationInterval': 60 * 60 * 3,
  'notificationText': "Hi, You've been notified! Open the app now!",
  'isReactionGameEnabled': true,
  'isQuestionnaireEnabled': true,
  'isCurrentActivityEnabled': true,
  'studyName': 'study1',
  'isStudy': true,
  'question1': 'How are you?',
  'question2': "How's your dog doing?",
  'question3': 'Can you tell me a couple more questions?',
  'question4': 'Can you read?',
  'question5': 'Why am I here? lol'
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

    _servicesProvider.configManager.loadDefaultConfig();
    test('default config should be available after loading it', () {
      expect(_servicesProvider.configManager.clientConfig.serverUrl,
          assertObject['serverUrl']);
      expect(_servicesProvider.configManager.clientConfig.notificationInterval,
          assertObject['notificationInterval']);
      expect(_servicesProvider.configManager.clientConfig.notificationText,
          assertObject['notificationText']);
      expect(_servicesProvider.configManager.clientConfig.isReactionGameEnabled,
          assertObject['isReactionGameEnabled']);
      expect(
          _servicesProvider.configManager.clientConfig.isQuestionnaireEnabled,
          assertObject['isQuestionnaireEnabled']);
      expect(
          _servicesProvider.configManager.clientConfig.isCurrentActivityEnabled,
          assertObject['isCurrentActivityEnabled']);
      expect(_servicesProvider.configManager.clientConfig.studyName,
          assertObject['studyName']);
      expect(_servicesProvider.configManager.clientConfig.isStudy,
          assertObject['isStudy']);
      expect(_servicesProvider.configManager.clientConfig.question1,
          assertObject['question1']);
      expect(_servicesProvider.configManager.clientConfig.question2,
          assertObject['question2']);
      expect(_servicesProvider.configManager.clientConfig.question3,
          assertObject['question3']);
      expect(_servicesProvider.configManager.clientConfig.question4,
          assertObject['question4']);
      expect(_servicesProvider.configManager.clientConfig.question5,
          assertObject['question5']);
    });

    // TODO: Add further tests for testing each method in ConfigManager
    // TODO: Add config tests for exception handling
  });
}
