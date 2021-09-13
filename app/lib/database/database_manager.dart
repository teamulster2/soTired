import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:so_tired/database/models/questionnaire/questionnaire_result.dart';
import 'package:so_tired/database/models/score/personal_high_score.dart';
import 'package:so_tired/database/models/user/user_log.dart';
import 'package:so_tired/database/models/user/user_state.dart';
import 'package:so_tired/utils.dart';

/// This class is responsible for all matters regarding database interactions.
/// It holds all boxes (comparable to tables in SQLite) and provides a CRUD API
/// to interact with the data.
class DatabaseManager {
  static DatabaseManager? _databaseManagerInstance =
      DatabaseManager._databaseManager();

  late final Box<PersonalHighScore> _personalHighScoreBox;
  late final Box<UserLog> _userLogBox;
  late final Box<UserState> _userStateBox;
  late final Box<QuestionnaireResult> _questionnaireResultBox;

  DatabaseManager._databaseManager();

  factory DatabaseManager() =>
      _databaseManagerInstance ?? DatabaseManager._databaseManager();

  Future<void> initDatabase() async {
    final String databasePath = await Utils.getLocalFilePath('database');
    Hive.init(databasePath);

    // ignore: cascade_invocations
    Hive.registerAdapter(PersonalHighScoreAdapter());
    // ignore: cascade_invocations
    Hive.registerAdapter(UserLogAdapter());
    // ignore: cascade_invocations
    Hive.registerAdapter(UserStateAdapter());
    // ignore: cascade_invocations
    Hive.registerAdapter(QuestionnaireResultAdapter());

    _personalHighScoreBox = await Hive.openBox('personalScoresBox');
    _userLogBox = await Hive.openBox('userLogBox');
    _userStateBox = await Hive.openBox('userStateBox');
    _questionnaireResultBox = await Hive.openBox('questionnaireResultBox');
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

  /// This method provides the ability to get an object by uuid.
  /// It is responsible for the [PersonalHighScore] hive box.
  /// It takes an uuid as argument and returns a single [PersonalHighScore]
  /// object.
  PersonalHighScore? getPersonalHighScoreById(String uuid) {
    for (final PersonalHighScore score in _personalHighScoreBox.values) {
      if (score.uuid == uuid) {
        return score;
      }
    }
  }

  /// This method provides the ability to get an object by uuid.
  /// It is responsible for the [UserLog] hive box.
  /// It takes an uuid as argument and returns a single [UserLog] object.
  UserLog? getUserLogById(String uuid) {
    for (final UserLog log in _userLogBox.values) {
      if (log.uuid == uuid) {
        return log;
      }
    }
  }

  /// This method provides the ability to get an object by uuid.
  /// It is responsible for the [UserState] hive box.
  /// It takes an uuid as argument and returns a single [UserState]
  /// object.
  UserState? getUserStateById(String uuid) {
    for (final UserState state in _userStateBox.values) {
      if (state.uuid == uuid) {
        return state;
      }
    }
  }

  /// This method provides the ability to get an object by uuid.
  /// It is responsible for the [QuestionnaireResult] hive box.
  /// It takes an uuid as argument and returns a single [QuestionnaireResult]
  /// object.
  QuestionnaireResult? getQuestionnaireResultById(String uuid) {
    for (final QuestionnaireResult result in _questionnaireResultBox.values) {
      if (result.uuid == uuid) {
        return result;
      }
    }
  }

  /// This method returns all entries from the [PersonalHighScore] box.
  /// It is null-aware. Therefore, the returned List is of type
  /// [PersonalScore?].
  List<PersonalHighScore?> getAllPersonalHighScores() {
    final List<PersonalHighScore?> returnList = <PersonalHighScore?>[];
    for (int i = 0; i < _personalHighScoreBox.length; i++) {
      returnList.add(_personalHighScoreBox.getAt(i));
    }
    return returnList;
  }

  /// This method returns all entries from the [UserLog] box.
  /// It is null-aware. Therefore, the returned List is of type
  /// [UserLog?].
  List<UserLog?> getAllUserLogs() {
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
    final List<QuestionnaireResult?> returnList = <QuestionnaireResult?>[];
    for (int i = 0; i < _questionnaireResultBox.length; i++) {
      returnList.add(_questionnaireResultBox.getAt(i));
    }
    return returnList;
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
    final Map<String, dynamic> userLogs = <String, dynamic>{};
    final Map<String, dynamic> userStates = <String, dynamic>{};
    final Map<String, dynamic> questionnaireResults = <String, dynamic>{};

    for (final UserLog? userLog in getAllUserLogs()) {
      final Map<String, dynamic>? userLogJson = userLog?.toJson();
      userLogs.addAll(userLogJson!);
    }
    returnMap.addAll(userLogs);

    for (final UserState? userState in getAllUserStates()) {
      final Map<String, dynamic>? userStateJson = userState?.toJson();
      userStates.addAll(userStateJson!);
    }
    returnMap.addAll(userStates);

    for (final QuestionnaireResult? questionnaireResult
        in getAllQuestionnaireResults()) {
      final Map<String, dynamic>? questionnaireResultJson =
          questionnaireResult?.toJson();
      questionnaireResults.addAll(questionnaireResultJson!);
    }
    returnMap.addAll(questionnaireResults);

    return returnMap;
  }

  /// This method closes the database connection.
  void closeDatabase() {
    Hive.close();
    _databaseManagerInstance = null;
  }
}
