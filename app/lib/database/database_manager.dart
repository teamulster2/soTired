import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:so_tired/database/models/module_type.dart';
import 'package:so_tired/database/models/questionnaire/questionnaire_answers.dart';
import 'package:so_tired/database/models/questionnaire/questionnaire_result.dart';
import 'package:so_tired/database/models/score/personal_high_score.dart';
import 'package:so_tired/database/models/settings/settings_object.dart';
import 'package:so_tired/database/models/user/user_access_method.dart';
import 'package:so_tired/database/models/user/user_log.dart';
import 'package:so_tired/database/models/user/user_state.dart';
import 'package:so_tired/exceptions/exceptions.dart';

/// This class is responsible for all matters regarding database interactions.
/// It holds all boxes (comparable to tables in SQLite) and provides a CRUD API
/// to interact with the data.
class DatabaseManager {
  static DatabaseManager? _databaseManagerInstance =
      DatabaseManager._databaseManager();

  final String _databasePath = 'database';

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
    Hive.registerAdapter(QuestionnaireAnswersAdapter());
    // ignore: cascade_invocations
    Hive.registerAdapter(ModuleTypeAdapter());
    // ignore: cascade_invocations
    Hive.registerAdapter(SettingsObjectAdapter());

    _personalHighScoreBox =
        await Hive.openBox<PersonalHighScore>('personalHighScoreBox');
    _userLogBox = await Hive.openBox<UserLog>('userLogBox');
    _userStateBox = await Hive.openBox<UserState>('userStateBox');
    _questionnaireResultBox =
        await Hive.openBox<QuestionnaireResult>('questionnaireResultBox');
    _settingsBox = await Hive.openBox('settingsBox');
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
          'You might want to restart your app to fix this.');
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

  /// This method exports all relevant information for the server and bundles
  /// them into one JSON object ([Map]).
  Map<String, dynamic> exportDatabaseForTransfer() {
    final Map<String, dynamic> returnMap = <String, dynamic>{};
    final List<Map<String, dynamic>> userLogs = <Map<String, dynamic>>[];
    final List<Map<String, dynamic>> userStates = <Map<String, dynamic>>[];
    final List<Map<String, dynamic>> questionnaireResults =
        <Map<String, dynamic>>[];

    try {
      for (final UserLog? userLog in getAllUserLogs()) {
        final Map<String, dynamic>? userLogJson = userLog?.toJson();
        userLogs.add(userLogJson!);
      }
      returnMap.addAll(<String, dynamic>{'UserLogs': userLogs});
    } catch (e) {
      rethrow;
    }

    try {
      for (final UserState? userState in getAllUserStates()) {
        final Map<String, dynamic>? userStateJson = userState?.toJson();
        userStates.add(userStateJson!);
      }
      returnMap.addAll(<String, dynamic>{'UserStates': userStates});
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
          <String, dynamic>{'QuestionnaireResults': questionnaireResults});
    } catch (e) {
      rethrow;
    }

    if (returnMap.isEmpty) {
      throw EmptyHiveBoxException('Nothing to return! All boxes are empty!');
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
}
