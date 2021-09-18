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
import 'package:so_tired/exceptions/exceptions.dart';
import 'package:so_tired/utils/utils.dart';

import 'database_manager_test.mocks.dart';

// ignore_for_file: always_specify_types

final DatabaseManager _databaseManager = MockDatabaseManager();

@GenerateMocks([Box, DatabaseManager])
void main() {
  // DatabaseManager variables
  final Box<PersonalHighScore> _personalHighScoreMockBox = MockBox();
  final Box<UserLog> _userLogMockBox = MockBox();
  final Box<UserState> _userStateMockBox = MockBox();
  final Box<QuestionnaireResult> _questionnaireResultMockBox = MockBox();

  final String _uuidPersonalHighScore = Utils.generateUuid();
  final String _uuidUserLog = Utils.generateUuid();
  final String _uuidUserState = Utils.generateUuid();
  final String _uuidUserState2 = Utils.generateUuid();
  final String _uuidQuestionnaireResult = Utils.generateUuid();

  final PersonalHighScore _personalHighScore = PersonalHighScore(
      _uuidPersonalHighScore, 33, ModuleType.psychomotorVigilanceTask);
  final UserLog _userLog = UserLog(
      _uuidUserLog,
      UserAccessMethod.notification,
      {
        ModuleType.mentalArithmetic: {'game1': false}
      },
      '2021-09-15T16:04:26.870744');
  final UserState _userState =
      UserState(_uuidUserState, 'running', Utils.stringToCodeUnits('🤪'));
  final UserState _userState2 =
      UserState(_uuidUserState2, 'working', Utils.stringToCodeUnits('🤪'));
  final QuestionnaireResult _questionnaireResult = QuestionnaireResult(
      _uuidQuestionnaireResult, {'firstQuestion': QuestionnaireAnswers.second});

  final Map<String, dynamic> assertJson = {
    'UserLogs': [
      {
        'uuid': _uuidUserLog,
        'accessMethod': UserAccessMethod.notification,
        'gamesExecuted': {
          ModuleType.mentalArithmetic: {'game1': false}
        },
        'timestamp': '2021-09-15T16:04:26.870744'
      }
    ],
    'UserStates': [
      {
        'uuid': _uuidUserState,
        'currentActivity': 'running',
        'currentMood': [240, 159, 164, 170]
      },
      {
        'uuid': _uuidUserState2,
        'currentActivity': 'working',
        'currentMood': [240, 159, 164, 170]
      }
    ],
    'QuestionnaireResults': [
      {
        'uuid': _uuidQuestionnaireResult,
        'questions': {'firstQuestion': QuestionnaireAnswers.second}
      }
    ]
  };

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
    when(_databaseManager.writeUserStates([_userState, _userState2]))
        .thenAnswer((_) => Future<void>(
            () => _userStateMockBox.addAll([_userState, _userState2])));
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
    when(_userStateMockBox.addAll([_userState, _userState2]))
        .thenAnswer((_) => Future<Iterable<int>>(() {
              _userStateList.addAll([_userState, _userState2]);
              return const Iterable<int>.empty();
            }));
    when(_questionnaireResultMockBox.addAll([_questionnaireResult]))
        .thenAnswer((_) => Future<Iterable<int>>(() {
              _questionnaireResultList.addAll([_questionnaireResult]);
              return const Iterable<int>.empty();
            }));

    when(_databaseManager.getPersonalHighScoreById(_uuidPersonalHighScore))
        .thenAnswer((_) {
      if (_personalHighScoreList.isEmpty) {
        throw EmptyHiveBoxException(
            'PersonalHighScoreBox does not contain entries. '
            'Go, store some to disk!');
      }

      PersonalHighScore? value;
      for (final PersonalHighScore score in _personalHighScoreList) {
        if (score.uuid == _uuidPersonalHighScore) {
          value = score;
        }
      }
      if (value == null) {
        throw HiveBoxNullValueException(
            'The provided uuid ($_uuidPersonalHighScore) does not refer '
            'to a value in _personalHighScoreBox.');
      }

      return value;
    });
    when(_databaseManager.getUserLogById(_uuidUserLog)).thenAnswer((_) {
      if (_userLogList.isEmpty) {
        throw EmptyHiveBoxException(
            'UserLogBox does not contain entries. Go, store some to disk!');
      }

      UserLog? value;
      for (final UserLog log in _userLogList) {
        if (log.uuid == _uuidUserLog) {
          value = log;
        }
      }
      if (value == null) {
        throw HiveBoxNullValueException(
            'The provided uuid ($_uuidUserLog) does not refer '
            'to a value in _userLogBox.');
      }

      return value;
    });
    when(_databaseManager.getUserStateById(_uuidUserState)).thenAnswer((_) {
      if (_userStateList.isEmpty) {
        throw EmptyHiveBoxException(
            'UserStateBox does not contain entries. Go, store some to disk!');
      }

      UserState? value;
      for (final UserState state in _userStateList) {
        if (state.uuid == _uuidUserState) {
          value = state;
        }
        // NOTE: add if statement for _uuidUserState2 if necessary
      }
      if (value == null) {
        throw HiveBoxNullValueException(
            'The provided uuid ($_uuidUserState) does not refer '
            'to a value in _userStateBox.');
      }

      return value;
    });
    when(_databaseManager.getQuestionnaireResultById(_uuidQuestionnaireResult))
        .thenAnswer((_) {
      if (_questionnaireResultList.isEmpty) {
        throw EmptyHiveBoxException(
            'QuestionnaireResultBox does not contain entries. '
            'Go, store some to disk!');
      }

      QuestionnaireResult? value;
      for (final QuestionnaireResult result in _questionnaireResultList) {
        if (result.uuid == _uuidQuestionnaireResult) {
          value = result;
        }
      }
      if (value == null) {
        throw HiveBoxNullValueException(
            'The provided uuid ($_uuidQuestionnaireResult) does not refer '
            'to a value in _questionnaireResultBox.');
      }

      return value;
    });
    when(_databaseManager.getPersonalHighScoreById('')).thenAnswer((_) {
      if (_personalHighScoreList.isEmpty) {
        throw EmptyHiveBoxException(
            'PersonalHighScoreBox does not contain entries. '
            'Go, store some to disk!');
      }

      PersonalHighScore? value;
      for (final PersonalHighScore score in _personalHighScoreList) {
        if (score.uuid == _uuidPersonalHighScore) {
          value = score;
        }
      }
      if (value == null) {
        throw HiveBoxNullValueException('The provided uuid () does not refer '
            'to a value in _personalHighScoreBox.');
      }

      return value;
    });
    when(_databaseManager.getUserLogById('')).thenAnswer((_) {
      if (_userLogList.isEmpty) {
        throw EmptyHiveBoxException(
            'UserLogBox does not contain entries. Go, store some to disk!');
      }

      UserLog? value;
      for (final UserLog log in _userLogList) {
        if (log.uuid == _uuidUserLog) {
          value = log;
        }
      }
      if (value == null) {
        throw HiveBoxNullValueException('The provided uuid () does not refer '
            'to a value in _userLogBox.');
      }

      return value;
    });
    when(_databaseManager.getUserStateById('')).thenAnswer((_) {
      if (_userStateList.isEmpty) {
        throw EmptyHiveBoxException(
            'UserStateBox does not contain entries. Go, store some to disk!');
      }

      UserState? value;
      for (final UserState state in _userStateList) {
        if (state.uuid == _uuidUserState) {
          value = state;
        }
        // NOTE: add if statement for _uuidUserState2 if necessary
      }
      if (value == null) {
        throw HiveBoxNullValueException('The provided uuid () does not refer '
            'to a value in _userStateBox.');
      }

      return value;
    });
    when(_databaseManager.getQuestionnaireResultById('')).thenAnswer((_) {
      if (_questionnaireResultList.isEmpty) {
        throw EmptyHiveBoxException(
            'QuestionnaireResultBox does not contain entries. '
            'Go, store some to disk!');
      }

      QuestionnaireResult? value;
      for (final QuestionnaireResult result in _questionnaireResultList) {
        if (result.uuid == _uuidQuestionnaireResult) {
          value = result;
        }
      }
      if (value == null) {
        throw HiveBoxNullValueException('The provided uuid () does not refer '
            'to a value in _questionnaireResultBox.');
      }

      return value;
    });

    when(_databaseManager.exportDatabaseForTransfer())
        .thenAnswer((_) => exportDatabaseForTransfer());

    test('boxes should be empty after initialization', () {
      throwsA(_databaseManager.getAllPersonalHighScores().length);
      throwsA(_databaseManager.getAllUserLogs().length);
      throwsA(_databaseManager.getAllUserStates().length);
      throwsA(_databaseManager.getAllQuestionnaireResults().length);
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

    test('null values should not be returned by get...ById', () {
      throwsA(() => _databaseManager.getPersonalHighScoreById(''));
      throwsA(() => _databaseManager.getUserLogById(''));
      throwsA(() => _databaseManager.getUserStateById(''));
      throwsA(() => _databaseManager.getQuestionnaireResultById(''));
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

    test('should return json containing all database entries', () async {
      await _databaseManager.writePersonalHighScores([_personalHighScore]);
      await _databaseManager.writeUserLogs([_userLog]);
      await _databaseManager.writeUserStates([_userState, _userState2]);
      await _databaseManager.writeQuestionnaireResults([_questionnaireResult]);

      final Map<String, dynamic> exportJson = exportDatabaseForTransfer();
      expect(exportJson, assertJson);
    });

    test('empty database should throw Exception when asked for export', () {
      throwsA(exportDatabaseForTransfer());
    });
  });
}

Map<String, dynamic> exportDatabaseForTransfer() {
  final Map<String, dynamic> returnMap = <String, dynamic>{};
  final List<Map<String, dynamic>> userLogs = <Map<String, dynamic>>[];
  final List<Map<String, dynamic>> userStates = <Map<String, dynamic>>[];
  final List<Map<String, dynamic>> questionnaireResults =
      <Map<String, dynamic>>[];

  try {
    for (final UserLog? userLog in _databaseManager.getAllUserLogs()) {
      final Map<String, dynamic>? userLogJson = userLog?.toJson();
      userLogs.add(userLogJson!);
    }
    returnMap.addAll(<String, dynamic>{'UserLogs': userLogs});
  } catch (e) {
    rethrow;
  }

  try {
    for (final UserState? userState in _databaseManager.getAllUserStates()) {
      final Map<String, dynamic>? userStateJson = userState?.toJson();
      userStates.add(userStateJson!);
    }
    returnMap.addAll(<String, dynamic>{'UserStates': userStates});
  } catch (e) {
    rethrow;
  }

  try {
    for (final QuestionnaireResult? questionnaireResult
        in _databaseManager.getAllQuestionnaireResults()) {
      final Map<String, dynamic>? questionnaireResultJson =
          questionnaireResult?.toJson();
      questionnaireResults.add(questionnaireResultJson!);
    }
    returnMap.addAll(
        <String, dynamic>{'QuestionnaireResults': questionnaireResults});
  } catch (e) {
    rethrow;
  }

  if (returnMap.isEmpty) {
    throw EmptyHiveBoxException('Nothing to return! All boxes are empty!');
  }
  return returnMap;
}
