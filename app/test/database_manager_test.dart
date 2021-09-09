// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:so_tired/database/models/activity/current_activity.dart';
// import 'package:so_tired/database/models/questionnaire/questionnaire_result.dart';
// import 'package:so_tired/database/models/score/personal_score.dart';
// import 'package:so_tired/database/models/user/user_access_method.dart';
// import 'package:so_tired/database/models/user/user_game_execution.dart';
// import 'package:so_tired/database/models/user/user_log.dart';
// import 'package:so_tired/services_provider.dart';
// import 'package:so_tired/ui/models/questionnaire_object.dart';
// import 'package:so_tired/utils.dart';
//
// // ignore_for_file: always_specify_types
//
// ServicesProvider _servicesProvider = ServicesProvider();
// bool _onDoneInitializing = false;
//
// // DatabaseManager variables
// final String _uuidPersonalScore = Utils.generateUuid();
// final String _uuidUserLog = Utils.generateUuid();
// final String _uuidCurrentActivity = Utils.generateUuid();
// final String _uuidQuestionnaireResult = Utils.generateUuid();
//
// final PersonalScore _personalScore = PersonalScore(_uuidPersonalScore, 33);
// final UserLog _userLog = UserLog(_uuidUserLog, UserAccessMethod.notification, {
//   UserGameExecution.reactionGame: {'game1': false}
// });
// final CurrentActivity _currentActivity =
//     CurrentActivity(_uuidCurrentActivity, 'running', 'sad');
// final QuestionnaireResult _questionnaireResult =
//     QuestionnaireResult(_uuidQuestionnaireResult, [
//   QuestionnaireObject(
//       'How are you doing?', ['Good', 'Not that good', 'Bad', 'Worse'])
// ]);

// NOTE: This is not working dues to deprecated methods within the flutter_test package.
// void main() {
//   group('DatabaseManager Basics', () {
//     setUpAll(() async {
//       // NOTE: This has been copied from https://flutter.dev/docs/cookbook/persistence/reading-writing-files#testing
//       // Create a temporary directory.
//       final Directory directory = await Directory.systemTemp.createTemp();
//
//       // Mock out the MethodChannel for the path_provider plugin.
//       const MethodChannel('plugins.flutter.io/path_provider')
//           .setMockMethodCallHandler((MethodCall methodCall) async {
//         // If you're getting the apps documents directory, return the path to the
//         // temp directory on the test environment instead.
//         if (methodCall.method == 'getApplicationDocumentsDirectory') {
//           return directory.path;
//         }
//         return null;
//       });
//     });
//
//     setUp(() {
//       _servicesProvider.init(() => _onDoneInitializing = true);
//       Timer.periodic(const Duration(microseconds: 10), (timer) {
//         if (_onDoneInitializing) {
//           timer.cancel();
//         }
//       });
//     });
//
//     test('boxes should be empty after initialization', () {
//       expect(
//           _servicesProvider.databaseManager.getAllPersonalScores().length, 0);
//       expect(_servicesProvider.databaseManager.getAllUserLogs().length, 0);
//       expect(_servicesProvider.databaseManager.getAllCurrentActivities().length,
//           0);
//       expect(
//           _servicesProvider.databaseManager.getAllQuestionnaireResults().length,
//           0);
//     });
//
//     test('objects should be available in database after write operation',
//         () async {
//       await Future.wait([
//         _servicesProvider.databaseManager.writePersonalScores([_personalScore]),
//         _servicesProvider.databaseManager.writeUserLogs([_userLog]),
//         _servicesProvider.databaseManager
//             .writeCurrentActivities([_currentActivity]),
//         _servicesProvider.databaseManager
//             .writeQuestionnaireResults([_questionnaireResult])
//       ]).then((val) {
//         // test via get...ById
//         expect(
//             _servicesProvider.databaseManager
//                 .getPersonalScoreById(_uuidPersonalScore),
//             _personalScore);
//         expect(_servicesProvider.databaseManager.getUserLogById(_uuidUserLog),
//             _userLog);
//         expect(
//             _servicesProvider.databaseManager
//                 .getCurrentActivityById(_uuidCurrentActivity),
//             _currentActivity);
//         expect(
//             _servicesProvider.databaseManager
//                 .getQuestionnaireResultById(_uuidQuestionnaireResult),
//             _questionnaireResult);
//
//         // test via getAll...
//         expect(_servicesProvider.databaseManager.getAllPersonalScores()[0],
//             _personalScore);
//         expect(_servicesProvider.databaseManager.getAllUserLogs()[0], _userLog);
//         expect(_servicesProvider.databaseManager.getAllCurrentActivities()[0],
//             _currentActivity);
//         expect(
//             _servicesProvider.databaseManager.getAllQuestionnaireResults()[0],
//             _questionnaireResult);
//       });
//     });
//     // TODO: Add database tests for exception handling
//
//     tearDown(() {
//       _servicesProvider.databaseManager.closeDatabase();
//       _onDoneInitializing = false;
//     });
//   });
// }

// TODO: Remove this when the real test is working again
void main() {}
