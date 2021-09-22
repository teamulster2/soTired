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

  final PersonalHighScore _personalHighScore = PersonalHighScore(
      _uuidPersonalHighScore, 33, ModuleType.psychomotorVigilanceTask);
  final UserLog _userLog = UserLog(
      _uuidUserLog,
      UserAccessMethod.notification,
      {
        ModuleType.psychomotorVigilanceTask: {'diffs': 500},
        ModuleType.spatialSpanTask: {'levels': 5}
      },
      '2021-09-15T16:04:26.870744');
  final UserState _userState = UserState(_uuidUserState,
      Utils.stringToCodeUnits('☕️'), Utils.stringToCodeUnits('😐'));
  final UserState _userState2 = UserState(_uuidUserState2,
      Utils.stringToCodeUnits('🏡'), Utils.stringToCodeUnits('🤩'));
  final QuestionnaireResult _questionnaireResult = QuestionnaireResult(
      _uuidQuestionnaireResult, {'How are you?': QuestionnaireAnswers.second});
  final SettingsObject _settings = SettingsObject(
      'http://www.example.com:50000', 'Default Study', '0.0.1+1');

  final Map<String, dynamic> assertJson = {
    'userLogs': [
      {
        'uuid': _uuidUserLog,
        'accessMethod': UserAccessMethod.notification,
        'gamesExecuted': {
          ModuleType.psychomotorVigilanceTask: {'diffs': 500},
          ModuleType.spatialSpanTask: {'levels': 5}
        },
        'timestamp': '2021-09-15T16:04:26.870744'
      }
    ],
    'userStates': [
      {
        'uuid': _uuidUserState,
        'currentActivity': [226, 152, 149, 239, 184, 143],
        'currentMood': [240, 159, 152, 144]
      },
      {
        'uuid': _uuidUserState2,
        'currentActivity': [240, 159, 143, 161],
        'currentMood': [240, 159, 164, 169]
      }
    ],
    'questionnaireResults': [
      {
        'uuid': _uuidQuestionnaireResult,
        'questions': {'How are you?': QuestionnaireAnswers.second}
      }
    ]
  };

  final Map<String, dynamic> adaptAssertMap = <String, dynamic>{
    'studyName': 'Default Study',
    'clientVersion': '0.0.1+1',
    'userLogs': [
      {
        'uuid': _uuidUserLog,
        'accessMethod': 'UserAccessMethod.notification',
        'ModuleType.spatialSpanTask': 5,
        'ModuleType.psychomotorVigilanceTask': 500,
        'timestamp': '2021-09-15T16:04:26.870744'
      }
    ],
    'userStates': [
      {
        'uuid': _uuidUserState,
        'currentActivity':
            Utils.codeUnitsToString([226, 152, 149, 239, 184, 143]),
        'currentMood': Utils.codeUnitsToString([240, 159, 152, 144])
      },
      {
        'uuid': _uuidUserState2,
        'currentActivity': Utils.codeUnitsToString([240, 159, 143, 161]),
        'currentMood': Utils.codeUnitsToString([240, 159, 164, 169])
      }
    ],
    'questionnaireResults': [
      {
        'uuid': _uuidQuestionnaireResult,
        'question': 'How are you?',
        'answer': 'QuestionnaireAnswers.second'
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

    when(_databaseManager.exportDatabaseForTransfer())
        .thenAnswer((_) => exportDatabaseForTransfer());

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
      _settingsObjectList.add(SettingsObject('', '', ''));
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

      final Map<String, dynamic> exportJson = exportDatabaseForTransfer();
      expect(exportJson, assertJson);
    });

    test('empty database should throw Exception when asked for export', () {
      expect(() => exportDatabaseForTransfer(),
          throwsA(isA<EmptyHiveBoxException>()));
    });

    test('should return map in server syntax', () async {
      await _databaseManager.writePersonalHighScores([_personalHighScore]);
      await _databaseManager.writeUserLogs([_userLog]);
      await _databaseManager.writeUserStates([_userState, _userState2]);
      await _databaseManager.writeQuestionnaireResults([_questionnaireResult]);
      await _databaseManager.writeSettings(_settings);

      final Map<String, dynamic> exportJson = exportDatabaseForTransfer();

      when(_databaseManager.adaptDatabaseExportToServerSyntax(exportJson))
          .thenAnswer((_) => adaptDatabaseExportToServerSyntax(exportJson));

      final Map<String, dynamic> serverSyntaxJson =
          adaptDatabaseExportToServerSyntax(exportJson);

      expect(serverSyntaxJson, adaptAssertMap);
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
    returnMap.addAll(<String, dynamic>{'userLogs': userLogs});
  } catch (e) {
    rethrow;
  }

  try {
    for (final UserState? userState in _databaseManager.getAllUserStates()) {
      final Map<String, dynamic>? userStateJson = userState?.toJson();
      userStates.add(userStateJson!);
    }
    returnMap.addAll(<String, dynamic>{'userStates': userStates});
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
  } catch (e) {
    rethrow;
  }

  if (returnMap.isEmpty) {
    throw EmptyHiveBoxException('Nothing to return! All boxes are empty!');
  }
  return returnMap;
}

Map<String, dynamic> adaptDatabaseExportToServerSyntax(
    Map<String, dynamic> exportMap) {
  final Map<String, dynamic> returnMap = <String, dynamic>{};
  final SettingsObject settings = _databaseManager.getSettings();

  // Add studyName, clientVersion
  returnMap.addAll(<String, dynamic>{
    'studyName': settings.studyName,
    'clientVersion': settings.appVersion
  });

  // Adapt userLogs
  final List<Map<String, dynamic>> userLogs = exportMap['userLogs'];
  final List<Map<String, dynamic>> userLogList = <Map<String, dynamic>>[];
  for (final Map<String, dynamic> userLog in userLogs) {
    final Map<ModuleType, Map<String, dynamic>> gamesExecuted =
        userLog['gamesExecuted'];
    final Map<String, dynamic> addition = <String, dynamic>{
      'uuid': userLog['uuid'],
      'accessMethod': '${userLog['accessMethod']}'
    };
    if (gamesExecuted.containsKey(ModuleType.psychomotorVigilanceTask)) {
      final Map<String, dynamic>? diffs =
          gamesExecuted[ModuleType.psychomotorVigilanceTask];
      addition
          .addAll({'${ModuleType.psychomotorVigilanceTask}': diffs!['diffs']});
    }
    if (gamesExecuted.containsKey(ModuleType.spatialSpanTask)) {
      final Map<String, dynamic>? levels =
          gamesExecuted[ModuleType.spatialSpanTask];
      addition.addAll({'${ModuleType.spatialSpanTask}': levels!['levels']});
    }
    addition.addAll({'timestamp': userLog['timestamp']});

    userLogList.add(addition);
  }
  returnMap['userLogs'] = userLogList;

  // Adapt userStates
  final List<Map<String, dynamic>> userStates = exportMap['userStates'];
  final List<Map<String, dynamic>> userStateList = <Map<String, dynamic>>[];
  for (final Map<String, dynamic>? userState in userStates) {
    final Map<String, dynamic> addition = <String, dynamic>{
      'uuid': userState!['uuid'],
      'currentActivity': Utils.codeUnitsToString(userState['currentActivity']),
      'currentMood': Utils.codeUnitsToString(userState['currentMood'])
    };
    userStateList.add(addition);
  }
  returnMap['userStates'] = userStateList;

  // Adapt questionnaireResults
  final List<Map<String, dynamic>> questionnaireResults =
      exportMap['questionnaireResults'];
  final List<Map<String, dynamic>> questionnaireResultList =
      <Map<String, dynamic>>[];
  for (final Map<String, dynamic>? questionnaireResult
      in questionnaireResults) {
    final Map<String, dynamic> questions = questionnaireResult!['questions'];
    final Map<String, dynamic> addition = <String, dynamic>{
      'uuid': questionnaireResult['uuid']
    };
    for (final String questionKey in questions.keys) {
      addition.addAll(<String, dynamic>{
        'question': questionKey,
        'answer': '${questions[questionKey]}'
      });
    }
    questionnaireResultList.add(addition);
  }
  returnMap['questionnaireResults'] = questionnaireResultList;

  return returnMap;
}
