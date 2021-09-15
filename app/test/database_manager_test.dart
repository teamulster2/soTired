import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:so_tired/database/database_manager.dart';
import 'package:so_tired/database/models/module_type.dart';
import 'package:so_tired/database/models/questionnaire/questionnaire_answers.dart';
import 'package:so_tired/database/models/questionnaire/questionnaire_result.dart';
import 'package:so_tired/database/models/score/personal_high_score.dart';
import 'package:so_tired/database/models/user/user_access_method.dart';
import 'package:so_tired/database/models/user/user_log.dart';
import 'package:so_tired/database/models/user/user_state.dart';
import 'package:so_tired/utils.dart';

import 'database_manager_test.mocks.dart';

// ignore_for_file: always_specify_types

@GenerateMocks([Box, DatabaseManager])
void main() {
  final DatabaseManager _databaseManager = MockDatabaseManager();

  // DatabaseManager variables
  final Box<PersonalHighScore> _personalHighScoreMockBox = MockBox();
  final Box<UserLog> _userLogMockBox = MockBox();
  final Box<UserState> _userStateMockBox = MockBox();
  final Box<QuestionnaireResult> _questionnaireResultMockBox = MockBox();

  final String _uuidPersonalHighScore = Utils.generateUuid();
  final String _uuidUserLog = Utils.generateUuid();
  final String _uuidUserState = Utils.generateUuid();
  final String _uuidQuestionnaireResult = Utils.generateUuid();

  final PersonalHighScore _personalHighScore = PersonalHighScore(
      _uuidPersonalHighScore, 33, ModuleType.psychomotorVigilanceTask);
  final UserLog _userLog = UserLog(
      _uuidUserLog,
      UserAccessMethod.notification,
      {
        ModuleType.mentalArithmetic: {'game1': false}
      },
      DateTime.now());
  final UserState _userState =
      UserState(_uuidUserState, 'running', Utils.stringToCodeUnits('🤪'));
  final QuestionnaireResult _questionnaireResult = QuestionnaireResult(
      _uuidQuestionnaireResult, {'firstQuestion': QuestionnaireAnswers.second});

  List<PersonalHighScore> _personalHighScoreList = [];
  List<UserLog> _userLogList = [];
  List<UserState> _userStateList = [];
  List<QuestionnaireResult> _questionnaireResultList = [];

  group('DatabaseManager Basics', () {
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
        return methodCall.method;
      });
    });

    setUp(() {
      _personalHighScoreList = [];
      _userLogList = [];
      _userStateList = [];
      _questionnaireResultList = [];
    });

    when(_databaseManager.getAllPersonalHighScores())
        .thenAnswer((_) => _personalHighScoreList);
    when(_databaseManager.getAllUserLogs()).thenAnswer((_) => _userLogList);
    when(_databaseManager.getAllUserStates()).thenAnswer((_) => _userStateList);
    when(_databaseManager.getAllQuestionnaireResults())
        .thenAnswer((_) => _questionnaireResultList);

    when(_databaseManager.writePersonalHighScores([_personalHighScore]))
        .thenAnswer((_) => Future<void>(
            () => _personalHighScoreMockBox.addAll([_personalHighScore])));
    when(_databaseManager.writeUserLogs([_userLog])).thenAnswer(
        (_) => Future<void>(() => _userLogMockBox.addAll([_userLog])));
    when(_databaseManager.writeUserStates([_userState])).thenAnswer(
        (_) => Future<void>(() => _userStateMockBox.addAll([_userState])));
    when(_databaseManager.writeQuestionnaireResults([_questionnaireResult]))
        .thenAnswer((_) => Future<void>(
            () => _questionnaireResultMockBox.addAll([_questionnaireResult])));

    when(_personalHighScoreMockBox.addAll([_personalHighScore]))
        .thenAnswer((_) => Future<Iterable<int>>(() {
              _personalHighScoreList.addAll([_personalHighScore]);
              return const Iterable<int>.empty();
            }));
    when(_userLogMockBox.addAll([_userLog]))
        .thenAnswer((_) => Future<Iterable<int>>(() {
              _userLogList.addAll([_userLog]);
              return const Iterable<int>.empty();
            }));
    when(_userStateMockBox.addAll([_userState]))
        .thenAnswer((_) => Future<Iterable<int>>(() {
              _userStateList.addAll([_userState]);
              return const Iterable<int>.empty();
            }));
    when(_questionnaireResultMockBox.addAll([_questionnaireResult]))
        .thenAnswer((_) => Future<Iterable<int>>(() {
              _questionnaireResultList.addAll([_questionnaireResult]);
              return const Iterable<int>.empty();
            }));

    when(_databaseManager.getPersonalHighScoreById(_uuidPersonalHighScore))
        .thenAnswer((_) {
      for (final PersonalHighScore score in _personalHighScoreList) {
        if (score.uuid == _uuidPersonalHighScore) {
          return score;
        }
      }
    });
    when(_databaseManager.getUserLogById(_uuidUserLog)).thenAnswer((_) {
      for (final UserLog log in _userLogList) {
        if (log.uuid == _uuidUserLog) {
          return log;
        }
      }
    });
    when(_databaseManager.getUserStateById(_uuidUserState)).thenAnswer((_) {
      for (final UserState state in _userStateList) {
        if (state.uuid == _uuidUserState) {
          return state;
        }
      }
    });
    when(_databaseManager.getQuestionnaireResultById(_uuidQuestionnaireResult))
        .thenAnswer((_) {
      for (final QuestionnaireResult result in _questionnaireResultList) {
        if (result.uuid == _uuidQuestionnaireResult) {
          return result;
        }
      }
    });

    test('boxes should be empty after initialization', () {
      expect(_databaseManager.getAllPersonalHighScores().length, 0);
      expect(_databaseManager.getAllUserLogs().length, 0);
      expect(_databaseManager.getAllUserStates().length, 0);
      expect(_databaseManager.getAllQuestionnaireResults().length, 0);
    });

    test('objects should be stored in database after write operation',
        () async {
      await _databaseManager.writePersonalHighScores([_personalHighScore]);
      verify(_personalHighScoreMockBox.addAll([_personalHighScore]));

      await _databaseManager.writeUserLogs([_userLog]);
      verify(_userLogMockBox.addAll([_userLog]));

      await _databaseManager.writeUserStates([_userState]);
      verify(_userStateMockBox.addAll([_userState]));

      await _databaseManager.writeQuestionnaireResults([_questionnaireResult]);
      verify(_questionnaireResultMockBox.addAll([_questionnaireResult]));
    });

    test('objects should be identified by uuid', () {
      _personalHighScoreList.add(_personalHighScore);
      _userLogList.add(_userLog);
      _userStateList.add(_userState);
      _questionnaireResultList.add(_questionnaireResult);

      expect(_databaseManager.getPersonalHighScoreById(_uuidPersonalHighScore),
          _personalHighScore);
      expect(_databaseManager.getUserLogById(_uuidUserLog), _userLog);
      expect(_databaseManager.getUserStateById(_uuidUserState), _userState);
      expect(
          _databaseManager.getQuestionnaireResultById(_uuidQuestionnaireResult),
          _questionnaireResult);
    });

    test('all objects should be available', () {
      _personalHighScoreList.add(_personalHighScore);
      _userLogList.add(_userLog);
      _userStateList.add(_userState);
      _questionnaireResultList.add(_questionnaireResult);

      expect(
          _databaseManager.getAllPersonalHighScores()[0], _personalHighScore);
      expect(_databaseManager.getAllUserLogs()[0], _userLog);
      expect(_databaseManager.getAllUserStates()[0], _userState);
      expect(_databaseManager.getAllQuestionnaireResults()[0],
          _questionnaireResult);
    });
  });
  // TODO: Add database tests for exception handling
}
