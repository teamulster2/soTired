import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:so_tired/database/models/questionnaire/questionnaire_result.dart';
import 'package:so_tired/database/models/score/personal_high_score.dart';
import 'package:so_tired/database/models/settings/settings_object.dart';
import 'package:so_tired/database/models/user/user_access_method.dart';
import 'package:so_tired/database/models/user/user_game_type.dart';
import 'package:so_tired/database/models/user/user_log.dart';
import 'package:so_tired/database/models/user/user_state.dart';
import 'package:so_tired/exceptions/exceptions.dart';
import 'package:so_tired/utils/utils.dart';

/// This class is responsible for all matters regarding database interactions.
/// It holds all boxes (comparable to tables in SQLite) and provides a CRUD API
/// to interact with the data.
class DatabaseManager {
  static DatabaseManager? _databaseManagerInstance =
      DatabaseManager._databaseManager();

  final String _databasePath = 'database';

  Map<String, dynamic> latestDatabaseExport = <String, dynamic>{};

  late final Box<PersonalHighScore> _personalHighScoreBox;
  late final Box<UserLog> _userLogBox;
  late final Box<UserState> _userStateBox;
  late final Box<QuestionnaireResult> _questionnaireResultBox;
  late final Box<SettingsObject> _settingsBox;

  DatabaseManager._databaseManager();

  factory DatabaseManager() =>
      _databaseManagerInstance ?? DatabaseManager._databaseManager();

  String get databasePath => _databasePath;

  Future<void> initDatabase(String databasePath) async {
    Hive.init(databasePath);

    // ignore: cascade_invocations
    Hive.registerAdapter(PersonalHighScoreAdapter());
    // ignore: cascade_invocations
    Hive.registerAdapter(UserAccessMethodAdapter());
    // ignore: cascade_invocations
    Hive.registerAdapter(UserLogAdapter());
    // ignore: cascade_invocations
    Hive.registerAdapter(UserStateAdapter());
    // ignore: cascade_invocations
    Hive.registerAdapter(QuestionnaireResultAdapter());
    // ignore: cascade_invocations
    Hive.registerAdapter(UserGameTypeAdapter());
    // ignore: cascade_invocations
    Hive.registerAdapter(SettingsObjectAdapter());

    _personalHighScoreBox =
        await Hive.openBox<PersonalHighScore>('personalHighScoreBox');
    _userLogBox = await Hive.openBox<UserLog>('userLogBox');
    _userStateBox = await Hive.openBox<UserState>('userStateBox');
    _questionnaireResultBox =
        await Hive.openBox<QuestionnaireResult>('questionnaireResultBox');
    _settingsBox = await Hive.openBox<SettingsObject>('settingsBox');

    if (_settingsBox.isNotEmpty &&
        getSettings().latestDatabaseExport != latestDatabaseExport) {
      latestDatabaseExport = getSettings().latestDatabaseExport!;
    }
  }

  /// This method provides write access to the database regarding all
  /// [PersonalHighScore] objects taken as [List] argument.
  Future<void> writePersonalHighScores(List<PersonalHighScore> scores) async =>
      _personalHighScoreBox.addAll(scores);

  /// This method provides write access to the database regarding all
  /// [UserLog] objects taken as [List] argument.
  Future<void> writeUserLogs(List<UserLog> logs) async =>
      _userLogBox.addAll(logs);

  /// This method provides write access to the database regarding all
  /// [UserState] objects taken as [List] argument.
  Future<void> writeUserStates(List<UserState> activities) async =>
      _userStateBox.addAll(activities);

  /// This method provides write access to the database regarding all
  /// [QuestionnaireResult] objects taken as [List] argument.
  Future<void> writeQuestionnaireResults(
          List<QuestionnaireResult> results) async =>
      _questionnaireResultBox.addAll(results);

  /// This method provides write access to the database regarding the
  /// [SettingsObject] object taken as single object argument.
  Future<void> writeSettings(SettingsObject settings) async {
    if (_settingsBox.isEmpty) {
      _settingsBox.add(settings);
    } else {
      await _settingsBox.clear();
      // ignore: cascade_invocations
      _settingsBox.add(settings);
    }
  }

  /// This method provides the ability to get an object by uuid.
  /// It is responsible for the [PersonalHighScore] hive box.
  /// It takes an uuid as argument and returns a single [PersonalHighScore]
  /// object.
  PersonalHighScore getPersonalHighScoreById(String uuid) {
    if (_personalHighScoreBox.isEmpty) {
      throw EmptyHiveBoxException(
          'PersonalHighScoreBox does not contain entries. '
          'Go, store some to disk!');
    }

    PersonalHighScore? value;
    for (final PersonalHighScore score in _personalHighScoreBox.values) {
      if (score.uuid == uuid) {
        value = score;
      }
    }
    if (value == null) {
      throw HiveBoxNullValueException(
          'The provided uuid ($uuid) does not refer '
          'to a value in _personalHighScoreBox.');
    }

    return value;
  }

  /// This method provides the ability to get an object by uuid.
  /// It is responsible for the [UserLog] hive box.
  /// It takes an uuid as argument and returns a single [UserLog] object.
  UserLog getUserLogById(String uuid) {
    if (_userLogBox.isEmpty) {
      throw EmptyHiveBoxException(
          'UserLogBox does not contain entries. Go, store some to disk!');
    }

    UserLog? value;
    for (final UserLog log in _userLogBox.values) {
      if (log.uuid == uuid) {
        value = log;
      }
    }
    if (value == null) {
      throw HiveBoxNullValueException(
          'The provided uuid ($uuid) does not refer '
          'to a value in _userLogBox.');
    }

    return value;
  }

  /// This method provides the ability to get an object by uuid.
  /// It is responsible for the [UserState] hive box.
  /// It takes an uuid as argument and returns a single [UserState]
  /// object.
  UserState getUserStateById(String uuid) {
    if (_userStateBox.isEmpty) {
      throw EmptyHiveBoxException(
          'UserStateBox does not contain entries. Go, store some to disk!');
    }

    UserState? value;
    for (final UserState state in _userStateBox.values) {
      if (state.uuid == uuid) {
        value = state;
      }
    }
    if (value == null) {
      throw HiveBoxNullValueException(
          'The provided uuid ($uuid) does not refer '
          'to a value in _userStateBox.');
    }

    return value;
  }

  /// This method provides the ability to get an object by uuid.
  /// It is responsible for the [QuestionnaireResult] hive box.
  /// It takes an uuid as argument and returns a single [QuestionnaireResult]
  /// object.
  QuestionnaireResult getQuestionnaireResultById(String uuid) {
    if (_questionnaireResultBox.isEmpty) {
      throw EmptyHiveBoxException(
          'QuestionnaireResultBox does not contain entries. '
          'Go, store some to disk!');
    }

    QuestionnaireResult? value;
    for (final QuestionnaireResult result in _questionnaireResultBox.values) {
      if (result.uuid == uuid) {
        value = result;
      }
    }
    if (value == null) {
      throw HiveBoxNullValueException(
          'The provided uuid ($uuid) does not refer '
          'to a value in _questionnaireResultBox.');
    }

    return value;
  }

  /// This method returns all entries from the [PersonalHighScore] box.
  /// It is null-aware. Therefore, the returned List is of type
  /// [PersonalScore?].
  List<PersonalHighScore> getAllPersonalHighScores() {
    if (_personalHighScoreBox.isEmpty) {
      throw EmptyHiveBoxException(
          'PersonalHighScoreBox does not contain entries. Go, store some to disk!');
    }
    final List<PersonalHighScore> returnList = <PersonalHighScore>[];
    for (int i = 0; i < _personalHighScoreBox.length; i++) {
      final PersonalHighScore? score = _personalHighScoreBox.getAt(i);
      if (score == null) {
        throw HiveBoxNullValueException(
            '_personalHighScoreBox contains null values. '
            'Reset the database to solve this issue!');
      }
      returnList.add(score);
    }
    return returnList;
  }

  /// This method returns all entries from the [UserLog] box.
  /// It is null-aware. Therefore, the returned List is of type
  /// [UserLog?].
  List<UserLog?> getAllUserLogs() {
    if (_userLogBox.isEmpty) {
      throw EmptyHiveBoxException(
          'UserLogBox does not contain entries. Go, store some to disk!');
    }
    final List<UserLog?> returnList = <UserLog?>[];
    for (int i = 0; i < _userLogBox.length; i++) {
      returnList.add(_userLogBox.getAt(i));
    }
    return returnList;
  }

  /// This method returns all entries from the [UserState] box.
  /// It is null-aware. Therefore, the returned List is of type
  /// [CurrentActivity?].
  List<UserState?> getAllUserStates() {
    if (_userStateBox.isEmpty) {
      throw EmptyHiveBoxException(
          'UserStateBox does not contain entries. Go, store some to disk!');
    }
    final List<UserState?> returnList = <UserState?>[];
    for (int i = 0; i < _userStateBox.length; i++) {
      returnList.add(_userStateBox.getAt(i));
    }
    return returnList;
  }

  /// This method returns all entries from the [QuestionnaireResult] box.
  /// It is null-aware. Therefore, the returned List is of type
  /// [QuestionnaireResult?].
  List<QuestionnaireResult?> getAllQuestionnaireResults() {
    if (_questionnaireResultBox.isEmpty) {
      throw EmptyHiveBoxException(
          'QuestionnaireResultBox does not contain entries. '
          'Go, store some to disk!');
    }
    final List<QuestionnaireResult?> returnList = <QuestionnaireResult?>[];
    for (int i = 0; i < _questionnaireResultBox.length; i++) {
      returnList.add(_questionnaireResultBox.getAt(i));
    }
    return returnList;
  }

  /// This method returns the current [SettingsObject] from [SettingsObject]
  /// box.
  SettingsObject getSettings() {
    if (_settingsBox.isEmpty) {
      throw EmptyHiveBoxException('SettingsBox does not contain entries. '
          'Please enter a valid server URL to fix this.');
    }

    return _settingsBox.values.first;
  }

  /// This method takes a [uuid] and deletes the corresponding value from
  /// the [PersonalHighScore] box.
  Future<void> deletePersonalHighScoreById(String uuid) async {
    final PersonalHighScore? score = getPersonalHighScoreById(uuid);
    _personalHighScoreBox.deleteAt(score!.key);
  }

  /// This method takes a [uuid] and deletes the corresponding value from
  /// the [UserLog] box.
  Future<void> deleteUserLogsById(String uuid) async {
    final UserLog? log = getUserLogById(uuid);
    _userLogBox.deleteAt(log!.key);
  }

  /// This method takes a [uuid] and deletes the corresponding value from
  /// the [UserState] box.
  Future<void> deleteUserStatesById(String uuid) async {
    final UserState? state = getUserStateById(uuid);
    _userStateBox.deleteAt(state!.key);
  }

  /// This method takes a [uuid] and deletes the corresponding value from
  /// the [QuestionnaireResult] box.
  Future<void> deleteQuestionnaireResultById(String uuid) async {
    final QuestionnaireResult? result = getQuestionnaireResultById(uuid);
    _questionnaireResultBox.deleteAt(result!.key);
  }

  /// This method exports all information stored in the database and bundles
  /// them into one JSON object ([Map]).
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
      for (final UserLog? userLog in getAllUserLogs()) {
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
      for (final UserState? userState in getAllUserStates()) {
        final Map<String, dynamic>? userStateJson = userState?.toJson();
        userStates.add(userStateJson!);
      }
      returnMap.addAll(<String, dynamic>{'userStates': userStates});
    } on EmptyHiveBoxException {
      returnMap
          .addAll(<String, dynamic>{'userStates': <Map<String, dynamic>>[]});
    } catch (e) {
      rethrow;
    }

    try {
      for (final QuestionnaireResult? questionnaireResult
          in getAllQuestionnaireResults()) {
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
          in getAllPersonalHighScores()) {
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
      final Map<String, dynamic> settingsJson = getSettings().toJson();
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

  /// This method closes the database connection.
  void closeDatabase() {
    Hive.close();
    // ignore: cascade_invocations
    // NOTE: uncomment this if the database should be deleted every time closing the app
    // Hive.deleteFromDisk();
    _databaseManagerInstance = null;
  }

  /// This method adapts the client database export to be able to satisfy
  /// the server's expectations regarding the json format.
  Map<String, dynamic> exportDatabaseAdaptedToServerSyntax() {
    final Map<String, dynamic> exportMap = exportDatabase();
    final Map<String, dynamic> returnMap = <String, dynamic>{};
    final SettingsObject settings = getSettings();

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
        late final String currentMood;
        switch (Utils.codeUnitsToString(userState!['currentMood'])) {
          case '😊':
            currentMood = 'happy';
            break;
          case '🤩':
            currentMood = 'excited';
            break;
          case '😐':
            currentMood = 'bored';
            break;
          case '😭':
            currentMood = 'sad';
            break;
          default:
            currentMood = '';
            break;
        }

        late final String currentActivity;
        final String currentActivityInput =
            Utils.codeUnitsToString(userState['currentActivity']);
        switch (currentActivityInput) {
          case '🏡':
            currentActivity = 'home';
            break;
          case '☕️':
            currentActivity = 'work';
            break;
          case '🏫':
            currentActivity = 'university';
            break;
          case '🛍':
            currentActivity = 'shops';
            break;
          case '👨‍👩‍👧‍👦':
            currentActivity = 'friends / family';
            break;
          case '⛳️':
            currentActivity = 'other';
            break;
          default:
            currentActivity = '';
            break;
        }
        final Map<String, dynamic> addition = <String, dynamic>{
          'uuid': userState['uuid'],
          'currentActivity': currentActivity,
          'currentMood': currentMood,
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
          // ignore: always_specify_types
          userLog.removeWhere((String key, value) => key == 'selfTestUuid');
          // ignore: always_specify_types
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
      // ignore: always_specify_types
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
      // ignore: always_specify_types
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
        final Map<String, dynamic> questions =
            questionnaireResult!['questions'];
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
}
