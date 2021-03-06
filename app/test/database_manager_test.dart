import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:so_tired/database/database_manager.dart';
import 'package:so_tired/database/models/user/user_game_type.dart';
import 'package:so_tired/database/models/questionnaire/questionnaire_result.dart';
import 'package:so_tired/database/models/score/personal_high_score.dart';
import 'package:so_tired/database/models/settings/settings_object.dart';
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
  final Box<SettingsObject> _settingsMockBox = MockBox();

  final String _uuidPersonalHighScore = Utils.generateUuid();
  final String _uuidUserLog = Utils.generateUuid();
  final String _uuidUserState = Utils.generateUuid();
  final String _uuidUserState2 = Utils.generateUuid();
  final String _uuidQuestionnaireResult = Utils.generateUuid();
  final String _uuidClient = Utils.generateUuid();
  final String _uuidSelfTest = Utils.generateUuid();
  final String _uuidSelfTest2 = Utils.generateUuid();

  final PersonalHighScore _personalHighScore = PersonalHighScore(
      _uuidPersonalHighScore, 33, UserGameType.psychomotorVigilanceTask);
  final UserLog _userLog = UserLog(
      _uuidUserLog,
      UserAccessMethod.notification,
      {
        UserGameType.psychomotorVigilanceTask: {
          'diffs': [234, 567, 890]
        },
        UserGameType.spatialSpanTask: {'levels': 5}
      },
      DateTime.parse('2021-09-15T16:04:26.870744'),
      _uuidSelfTest);
  final UserState _userState = UserState(_uuidUserState, 'work', 'bored',
      DateTime.parse('2021-09-15T16:04:26.870744'), _uuidSelfTest);
  final UserState _userState2 = UserState(_uuidUserState2, 'home', 'excited',
      DateTime.parse('2021-09-15T16:04:26.870744'), _uuidSelfTest2);
  final QuestionnaireResult _questionnaireResult = QuestionnaireResult(
      _uuidQuestionnaireResult,
      {'How are you?': 'Good'},
      DateTime.parse('2021-09-15T16:04:26.870744'));
  final SettingsObject _settings = SettingsObject(
      'http://www.example.com:50000',
      'Default Study',
      '0.0.1+1',
      _uuidClient, <String, dynamic>{});

  final Map<String, dynamic> exportAssertMap = {
    'userLogs': [
      {
        'uuid': _uuidUserLog,
        'accessMethod': UserAccessMethod.notification,
        'gamesExecuted': {
          UserGameType.psychomotorVigilanceTask: {
            'diffs': [234, 567, 890]
          },
          UserGameType.spatialSpanTask: {'levels': 5}
        },
        'timestamp': DateTime.parse('2021-09-15T16:04:26.870744'),
        'selfTestUuid': _uuidSelfTest
      }
    ],
    'userStates': [
      {
        'uuid': _uuidUserState,
        'currentActivity': 'work',
        'currentMood': 'bored',
        'timestamp': DateTime.parse('2021-09-15T16:04:26.870744'),
        'selfTestUuid': _uuidSelfTest
      },
      {
        'uuid': _uuidUserState2,
        'currentActivity': 'home',
        'currentMood': 'excited',
        'timestamp': DateTime.parse('2021-09-15T16:04:26.870744'),
        'selfTestUuid': _uuidSelfTest2
      }
    ],
    'questionnaireResults': [
      {
        'uuid': _uuidQuestionnaireResult,
        'questions': {'How are you?': 'Good'},
        'timestamp': DateTime.parse('2021-09-15T16:04:26.870744')
      }
    ],
    'personalHighScores': [
      {
        'uuid': _uuidPersonalHighScore,
        'gameScore': 33,
        'gameType': UserGameType.psychomotorVigilanceTask
      }
    ],
    'settings': [
      {
        'serverUrl': 'http://www.example.com:50000',
        'studyName': 'Default Study',
        'appVersion': '0.0.1+1',
        'clientUuid': _uuidClient,
        'latestDatabaseExport': {}
      }
    ]
  };

  final Map<String, dynamic> adaptExportAssertMap = <String, dynamic>{
    'studyName': 'Default Study',
    'clientVersion': '0.0.1+1',
    'clientUuid': _uuidClient,
    'runList': [
      {
        'selfTestUuid': _uuidSelfTest,
        'userLog': {
          'uuid': _uuidUserLog,
          'accessMethod': 'UserAccessMethod.notification',
          'UserGameType.spatialSpanTask': 5,
          'UserGameType.psychomotorVigilanceTask': [234, 567, 890],
          'timestamp': '2021-09-15T16:04:26.870744'
        },
        'userState': {
          'uuid': _uuidUserState,
          'currentActivity': 'work',
          'currentMood': 'bored',
          'timestamp': '2021-09-15T16:04:26.870744'
        },
      },
      {
        'selfTestUuid': _uuidSelfTest2,
        'userLog': {},
        'userState': {
          'uuid': _uuidUserState2,
          'currentActivity': 'home',
          'currentMood': 'excited',
          'timestamp': '2021-09-15T16:04:26.870744'
        }
      }
    ],
    'questionnaireResults': [
      {
        'uuid': _uuidQuestionnaireResult,
        'question': 'How are you?',
        'answer': 'Good',
        'timestamp': '2021-09-15T16:04:26.870744'
      }
    ]
  };

  List<PersonalHighScore> _personalHighScoreList = [];
  List<UserLog> _userLogList = [];
  List<UserState> _userStateList = [];
  List<QuestionnaireResult> _questionnaireResultList = [];
  List<SettingsObject> _settingsObjectList = [];

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
      _settingsObjectList = [];
    });

    when(_databaseManager.getAllPersonalHighScores()).thenAnswer((_) {
      if (_personalHighScoreList.isEmpty) {
        throw EmptyHiveBoxException(
            'UserStateBox does not contain entries. Go, store some to disk!');
      }
      return _personalHighScoreList;
    });
    when(_databaseManager.getAllUserLogs()).thenAnswer((_) {
      if (_userLogList.isEmpty) {
        throw EmptyHiveBoxException(
            'UserStateBox does not contain entries. Go, store some to disk!');
      }
      return _userLogList;
    });
    when(_databaseManager.getAllUserStates()).thenAnswer((_) {
      if (_userStateList.isEmpty) {
        throw EmptyHiveBoxException(
            'UserStateBox does not contain entries. Go, store some to disk!');
      }
      return _userStateList;
    });
    when(_databaseManager.getAllQuestionnaireResults()).thenAnswer((_) {
      if (_questionnaireResultList.isEmpty) {
        throw EmptyHiveBoxException(
            'UserStateBox does not contain entries. Go, store some to disk!');
      }
      return _questionnaireResultList;
    });
    when(_databaseManager.getSettings()).thenAnswer((_) {
      if (_settingsObjectList.isEmpty) {
        throw EmptyHiveBoxException('SettingsBox does not contain entries. '
            'You might want to restart your app to fix this.');
      }

      return _settingsObjectList.first;
    });

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
    when(_databaseManager.writeSettings(_settings))
        .thenAnswer((_) => Future<void>(() async {
              if (_settingsObjectList.isEmpty) {
                await _settingsMockBox.add(_settings);
              } else {
                _settingsObjectList.clear();
                // ignore: cascade_invocations
                await _settingsMockBox.add(_settings);
              }
            }));

    when(_settingsMockBox.add(_settings)).thenAnswer((_) => Future<int>(() {
          _settingsObjectList.add(_settings);
          return Future.value(0);
        }));

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
        if (score.uuid == '') {
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
        if (log.uuid == '') {
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
        if (state.uuid == '') {
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
        if (result.uuid == '') {
          value = result;
        }
      }
      if (value == null) {
        throw HiveBoxNullValueException('The provided uuid () does not refer '
            'to a value in _questionnaireResultBox.');
      }

      return value;
    });

    when(_databaseManager.exportDatabase()).thenAnswer((_) => exportDatabase());

    test('boxes should be empty after initialization', () {
      expect(() => _databaseManager.getAllPersonalHighScores(),
          throwsA(isA<EmptyHiveBoxException>()));
      expect(() => _databaseManager.getAllUserLogs(),
          throwsA(isA<EmptyHiveBoxException>()));
      expect(() => _databaseManager.getAllUserStates(),
          throwsA(isA<EmptyHiveBoxException>()));
      expect(() => _databaseManager.getAllQuestionnaireResults(),
          throwsA(isA<EmptyHiveBoxException>()));
      expect(() => _databaseManager.getSettings(),
          throwsA(isA<EmptyHiveBoxException>()));
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

      await _databaseManager.writeSettings(_settings);
      verify(_settingsMockBox.add(_settings));
    });

    test('settings should only contain one object', () async {
      _settingsObjectList
          .add(SettingsObject('', '', '', '', <String, dynamic>{}));
      // ignore: cascade_invocations
      await _databaseManager.writeSettings(_settings);

      expect(_settingsObjectList.length, 1);
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
      _personalHighScoreList.add(_personalHighScore);
      _userLogList.add(_userLog);
      _userStateList.add(_userState);
      _questionnaireResultList.add(_questionnaireResult);

      expect(() => _databaseManager.getPersonalHighScoreById(''),
          throwsA(isA<HiveBoxNullValueException>()));
      expect(() => _databaseManager.getUserLogById(''),
          throwsA(isA<HiveBoxNullValueException>()));
      expect(() => _databaseManager.getUserStateById(''),
          throwsA(isA<HiveBoxNullValueException>()));
      expect(() => _databaseManager.getQuestionnaireResultById(''),
          throwsA(isA<HiveBoxNullValueException>()));
    });

    test('all objects should be available', () {
      _personalHighScoreList.add(_personalHighScore);
      _userLogList.add(_userLog);
      _userStateList.add(_userState);
      _questionnaireResultList.add(_questionnaireResult);
      _settingsObjectList.add(_settings);

      expect(
          _databaseManager.getAllPersonalHighScores()[0], _personalHighScore);
      expect(_databaseManager.getAllUserLogs()[0], _userLog);
      expect(_databaseManager.getAllUserStates()[0], _userState);
      expect(_databaseManager.getAllQuestionnaireResults()[0],
          _questionnaireResult);
      expect(_databaseManager.getSettings(), _settings);
    });

    test('should return json containing all database entries', () async {
      await _databaseManager.writePersonalHighScores([_personalHighScore]);
      await _databaseManager.writeUserLogs([_userLog]);
      await _databaseManager.writeUserStates([_userState, _userState2]);
      await _databaseManager.writeQuestionnaireResults([_questionnaireResult]);
      await _databaseManager.writeSettings(_settings);

      final Map<String, dynamic> exportMap = exportDatabase();
      expect(exportMap, exportAssertMap);
    });

    test('empty database should throw Exception when asked for export', () {
      expect(() => exportDatabase(), throwsA(isA<EmptyHiveBoxException>()));
    });

    test('should return map in server syntax', () async {
      await _databaseManager.writePersonalHighScores([_personalHighScore]);
      await _databaseManager.writeUserLogs([_userLog]);
      await _databaseManager.writeUserStates([_userState, _userState2]);
      await _databaseManager.writeQuestionnaireResults([_questionnaireResult]);
      await _databaseManager.writeSettings(_settings);

      when(_databaseManager.exportDatabaseAdaptedToServerSyntax())
          .thenAnswer((_) => exportDatabaseAdaptedToServerSyntax());

      final Map<String, dynamic> serverSyntaxJson =
          exportDatabaseAdaptedToServerSyntax();

      expect(serverSyntaxJson, adaptExportAssertMap);
    });
  });
}

Map<String, dynamic> exportDatabase() {
  final Map<String, dynamic> returnMap = <String, dynamic>{};
  final List<Map<String, dynamic>> userLogs = <Map<String, dynamic>>[];
  final List<Map<String, dynamic>> userStates = <Map<String, dynamic>>[];
  final List<Map<String, dynamic>> questionnaireResults =
      <Map<String, dynamic>>[];
  final List<Map<String, dynamic>> personalHighScores =
      <Map<String, dynamic>>[];
  final List<Map<String, dynamic>> settings = <Map<String, dynamic>>[];

  try {
    for (final UserLog? userLog in _databaseManager.getAllUserLogs()) {
      final Map<String, dynamic>? userLogJson = userLog?.toJson();
      userLogs.add(userLogJson!);
    }
    returnMap.addAll(<String, dynamic>{'userLogs': userLogs});
  } on EmptyHiveBoxException {
    returnMap.addAll(<String, dynamic>{'userLogs': <Map<String, dynamic>>[]});
  } catch (e) {
    rethrow;
  }

  try {
    for (final UserState? userState in _databaseManager.getAllUserStates()) {
      final Map<String, dynamic>? userStateJson = userState?.toJson();
      userStates.add(userStateJson!);
    }
    returnMap.addAll(<String, dynamic>{'userStates': userStates});
  } on EmptyHiveBoxException {
    returnMap.addAll(<String, dynamic>{'userStates': <Map<String, dynamic>>[]});
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
        <String, dynamic>{'questionnaireResults': questionnaireResults});
  } on EmptyHiveBoxException {
    returnMap.addAll(
        <String, dynamic>{'questionnaireResults': <Map<String, dynamic>>[]});
  } catch (e) {
    rethrow;
  }

  try {
    for (final PersonalHighScore? personalHighScore
        in _databaseManager.getAllPersonalHighScores()) {
      final Map<String, dynamic>? scoreJson = personalHighScore?.toJson();
      personalHighScores.add(scoreJson!);
    }
    returnMap
        .addAll(<String, dynamic>{'personalHighScores': personalHighScores});
  } on EmptyHiveBoxException {
    returnMap.addAll(
        <String, dynamic>{'personalHighScores': <Map<String, dynamic>>[]});
  } catch (e) {
    rethrow;
  }

  try {
    final Map<String, dynamic> settingsJson =
        _databaseManager.getSettings().toJson();
    settings.add(settingsJson);
    returnMap.addAll(<String, dynamic>{'settings': settings});
  } on EmptyHiveBoxException {
    returnMap.addAll(<String, dynamic>{'settings': <Map<String, dynamic>>[]});
  } catch (e) {
    rethrow;
  }

  if (List<Map<String, dynamic>>.from(returnMap['userLogs']).isEmpty &&
      List<Map<String, dynamic>>.from(returnMap['userStates']).isEmpty &&
      List<Map<String, dynamic>>.from(returnMap['questionnaireResults'])
          .isEmpty &&
      List<Map<String, dynamic>>.from(returnMap['personalHighScores'])
          .isEmpty &&
      List<Map<String, dynamic>>.from(returnMap['settings']).isEmpty) {
    throw EmptyHiveBoxException('Currently you have not created any results. '
        'Please participate in the self-test or answer the questionnaire '
        'first!');
  }

  return returnMap;
}

Map<String, dynamic> exportDatabaseAdaptedToServerSyntax() {
  final Map<String, dynamic> exportMap = exportDatabase();
  final Map<String, dynamic> returnMap = <String, dynamic>{};
  final SettingsObject settings = _databaseManager.getSettings();

  // Add studyName, clientVersion
  returnMap.addAll(<String, dynamic>{
    'studyName': settings.studyName,
    'clientVersion': settings.appVersion,
    'clientUuid': settings.clientUuid
  });

  // Introduce runList
  final List<Map<String, dynamic>> runList = <Map<String, dynamic>>[];
  final List<Map<String, dynamic>> userLogs = exportMap['userLogs'];
  final List<Map<String, dynamic>> userStates = exportMap['userStates'];

  // Preprocess userLogs
  final List<Map<String, dynamic>> preprocessedUserLogs =
      <Map<String, dynamic>>[];
  if (userLogs.isNotEmpty) {
    for (final Map<String, dynamic> userLog in userLogs) {
      final Map<UserGameType, Map<String, dynamic>> gamesExecuted =
          userLog['gamesExecuted'];
      final Map<String, dynamic> addition = <String, dynamic>{
        'uuid': userLog['uuid'],
        'accessMethod': '${userLog['accessMethod']}'
      };
      if (gamesExecuted.containsKey(UserGameType.psychomotorVigilanceTask)) {
        final Map<String, dynamic>? diffs =
            gamesExecuted[UserGameType.psychomotorVigilanceTask];
        addition.addAll(<String, List<int>>{
          '${UserGameType.psychomotorVigilanceTask}': diffs!['diffs']
        });
      }
      if (gamesExecuted.containsKey(UserGameType.spatialSpanTask)) {
        final Map<String, dynamic>? levels =
            gamesExecuted[UserGameType.spatialSpanTask];
        addition.addAll(<String, int>{
          '${UserGameType.spatialSpanTask}': levels!['levels']
        });
      }
      addition.addAll(<String, dynamic>{
        'timestamp': (userLog['timestamp'] as DateTime).toIso8601String(),
        'selfTestUuid': userLog['selfTestUuid']
      });

      preprocessedUserLogs.add(addition);
    }
  }

  // Preprocess userStates
  final List<Map<String, dynamic>> preprocessedUserStates =
      <Map<String, dynamic>>[];
  if (userStates.isNotEmpty) {
    for (final Map<String, dynamic>? userState in userStates) {
      final Map<String, dynamic> addition = <String, dynamic>{
        'uuid': userState!['uuid'],
        'currentActivity': userState['currentActivity'],
        'currentMood': userState['currentMood'],
        'timestamp': (userState['timestamp'] as DateTime).toIso8601String(),
        'selfTestUuid': userState['selfTestUuid']
      };

      preprocessedUserStates.add(addition);
    }
  }

  // Assemble runList
  for (int i = 0; i < preprocessedUserLogs.length; i++) {
    final Map<String, dynamic> userLog = preprocessedUserLogs[i];
    for (int j = 0; j < preprocessedUserStates.length; j++) {
      final Map<String, dynamic> userState = preprocessedUserStates[j];
      if (userLog['selfTestUuid'] == userState['selfTestUuid']) {
        final Map<String, dynamic> addition = <String, dynamic>{
          'selfTestUuid': userLog['selfTestUuid']
        };
        userLog.removeWhere((String key, value) => key == 'selfTestUuid');
        userState.removeWhere((String key, value) => key == 'selfTestUuid');
        addition.addAll(
            <String, dynamic>{'userLog': userLog, 'userState': userState});
        preprocessedUserLogs.removeAt(i);
        // NOTE: Avoid race condition while removing element from Iterable of current loop
        i--;
        preprocessedUserStates.removeAt(j);
        // NOTE: Avoid race condition while removing element from Iterable of current loop
        j--;

        runList.add(addition);
      }
    }
  }

  for (final Map<String, dynamic> userLog in preprocessedUserLogs) {
    final Map<String, dynamic> addition = <String, dynamic>{
      'selfTestUuid': userLog['selfTestUuid']
    };
    userLog.removeWhere((String key, value) => key == 'selfTestUuid');
    addition.addAll(<String, dynamic>{
      'userLog': userLog,
      'userState': <String, dynamic>{}
    });
    runList.add(addition);
  }

  for (final Map<String, dynamic> userState in preprocessedUserStates) {
    final Map<String, dynamic> addition = <String, dynamic>{
      'selfTestUuid': userState['selfTestUuid']
    };
    userState.removeWhere((String key, value) => key == 'selfTestUuid');
    addition.addAll(<String, dynamic>{
      'userLog': <String, dynamic>{},
      'userState': userState
    });
    runList.add(addition);
  }
  returnMap['runList'] = runList;

  // Adapt questionnaireResults
  final List<Map<String, dynamic>> questionnaireResults =
      exportMap['questionnaireResults'];
  if (questionnaireResults.isEmpty) {
    returnMap['questionnaireResults'] = <Map<String, dynamic>>[];
  } else {
    final List<Map<String, dynamic>> questionnaireResultList =
        <Map<String, dynamic>>[];
    for (final Map<String, dynamic>? questionnaireResult
        in questionnaireResults) {
      final Map<String, dynamic> questions = questionnaireResult!['questions'];
      Map<String, dynamic> addition = <String, dynamic>{};
      for (final String questionKey in questions.keys) {
        addition.addAll(<String, dynamic>{
          'uuid': questionnaireResult['uuid'],
          'question': questionKey,
          'answer': '${questions[questionKey]}',
          'timestamp':
              (questionnaireResult['timestamp'] as DateTime).toIso8601String()
        });
        questionnaireResultList.add(addition);
        addition = <String, dynamic>{};
      }
    }
    returnMap['questionnaireResults'] = questionnaireResultList;
  }

  return returnMap;
}
