import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:so_tired/config/config_manager.dart';
import 'package:so_tired/config/config_utils.dart';

late String fileContents;

setUpAll() async {
  final fileObject =
      await ConfigUtils.getConfigFileObject('client_config.json');
  fileContents = await fileObject.readAsString();
  // Create a temporary directory.
  final directory = await Directory.systemTemp.createTemp();

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
  // final Map<String, dynamic> assertObject = {
  //   'serverUrl': 'http://localhost',
  //   'notificationInterval': 60 * 60 * 3,
  //   'notificationText': 'Hi, You\'ve been notified! Open the app now!',
  //   'isReactionGameEnabled': true,
  //   'isQuestionnaireEnabled': true,
  //   'isCurrentActivityEnabled': true,
  //   'studyName': 'study1',
  //   'isStudy': true,
  //   'question1': 'How are you?',
  //   'question2': 'How\'s your dog doing?',
  //   'question3': 'Can you tell me a couple more questions?',
  //   'question4': 'Can you read?',
  //   'question5': 'Why am I here? lol'
  // };
  final fileContentsJson = jsonDecode(fileContents);
  final ConfigManager configManager = ConfigManager();

  test(
      'Test json read/write operation in ConfigManager class.',
      () => {
            expect(configManager.clientConfig.serverUrl,
                fileContentsJson['serverUrl']),
            expect(configManager.clientConfig.notificationInterval,
                fileContentsJson['notificationInterval']),
            expect(configManager.clientConfig.notificationText,
                fileContentsJson['notificationText']),
            expect(configManager.clientConfig.isReactionGameEnabled,
                fileContentsJson['isReactionGameEnabled']),
            expect(configManager.clientConfig.isQuestionnaireEnabled,
                fileContentsJson['isQuestionnaireEnabled']),
            expect(configManager.clientConfig.isCurrentActivityEnabled,
                fileContentsJson['isCurrentActivityEnabled']),
            expect(configManager.clientConfig.studyName,
                fileContentsJson['studyName']),
            expect(configManager.clientConfig.isStudy,
                fileContentsJson['isStudy']),
            expect(configManager.clientConfig.question1,
                fileContentsJson['question1']),
            expect(configManager.clientConfig.question2,
                fileContentsJson['question2']),
            expect(configManager.clientConfig.question3,
                fileContentsJson['question3']),
            expect(configManager.clientConfig.question4,
                fileContentsJson['question4']),
            expect(configManager.clientConfig.question5,
                fileContentsJson['question5'])
          });

  // TODO: Add further tests for testing each method in ConfigManager when implementing adjustable settings for user
}
