import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:so_tired/config/config_manager.dart';

final ConfigManager configManager = ConfigManager();
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

setUpAll() async {
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
}

void main() {
  configManager.loadDefaultConfig();

  test(
      'Test json defaultConfig in ConfigManager class.',
      () => <void>{
            expect(configManager.clientConfig.serverUrl,
                assertObject['serverUrl']),
            expect(configManager.clientConfig.notificationInterval,
                assertObject['notificationInterval']),
            expect(configManager.clientConfig.notificationText,
                assertObject['notificationText']),
            expect(configManager.clientConfig.isReactionGameEnabled,
                assertObject['isReactionGameEnabled']),
            expect(configManager.clientConfig.isQuestionnaireEnabled,
                assertObject['isQuestionnaireEnabled']),
            expect(configManager.clientConfig.isCurrentActivityEnabled,
                assertObject['isCurrentActivityEnabled']),
            expect(configManager.clientConfig.studyName,
                assertObject['studyName']),
            expect(configManager.clientConfig.isStudy, assertObject['isStudy']),
            expect(configManager.clientConfig.question1,
                assertObject['question1']),
            expect(configManager.clientConfig.question2,
                assertObject['question2']),
            expect(configManager.clientConfig.question3,
                assertObject['question3']),
            expect(configManager.clientConfig.question4,
                assertObject['question4']),
            expect(
                configManager.clientConfig.question5, assertObject['question5'])
          });

  // TODO: Add further tests for testing each method in ConfigManager
  // TODO: Probably add tests for ConfigUtils, too
}
