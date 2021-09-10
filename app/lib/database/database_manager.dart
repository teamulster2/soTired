import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:so_tired/database/models/user/user_state.dart';
import 'package:so_tired/database/models/questionnaire/questionnaire_result.dart';
import 'package:so_tired/database/models/score/personal_high_score.dart';
import 'package:so_tired/database/models/user/user_log.dart';
import 'package:so_tired/utils.dart';

/// This class is responsible for all matters regarding database interactions.
/// It holds all boxes (comparable to tables in SQLite) and provides a CRUD API
/// to interact with the data.
class DatabaseManager {
  static DatabaseManager? _databaseManagerInstance =
      DatabaseManager._databaseManager();

  late final Box<PersonalHighScore> _personalScoreBox;
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

    _personalScoreBox = await Hive.openBox('personalScoresBox');
    _userLogBox = await Hive.openBox('userLogBox');
    _userStateBox = await Hive.openBox('userStateBox');
    _questionnaireResultBox = await Hive.openBox('questionnaireResultBox');
  }

  /// This method provides write access to the database regarding all
  /// [PersonalHighScore] objects taken as [List] argument.
  Future<void> writePersonalHighScores(List<PersonalHighScore> scores) async =>
      _personalScoreBox.addAll(scores);

  /// This method provides write access to the database regarding all
  /// [UserLog] objects taken as [List] argument.
  Future<void> writeUserLogs(List<UserLog> logs) async =>
      _userLogBox.addAll(logs);

  /// This method provides write access to the database regarding all
  /// [UserState] objects taken as [List] argument.
  Future<void> writeCurrentActivities(List<UserState> activities) async =>
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
  PersonalHighScore? getPersonalHighScoreById(String uuid) =>
      _personalScoreBox.get(uuid);

  /// This method provides the ability to get an object by uuid.
  /// It is responsible for the [UserLog] hive box.
  /// It takes an uuid as argument and returns a single [UserLog] object.
  UserLog? getUserLogById(String uuid) => _userLogBox.get(uuid);

  /// This method provides the ability to get an object by uuid.
  /// It is responsible for the [UserState] hive box.
  /// It takes an uuid as argument and returns a single [UserState]
  /// object.
  UserState? getCurrentActivityById(String uuid) =>
      _userStateBox.get(uuid);

  /// This method provides the ability to get an object by uuid.
  /// It is responsible for the [QuestionnaireResult] hive box.
  /// It takes an uuid as argument and returns a single [QuestionnaireResult]
  /// object.
  QuestionnaireResult? getQuestionnaireResultById(String uuid) =>
      _questionnaireResultBox.get(uuid);

  /// This method returns all entries from the [PersonalHighScore] box.
  /// It is null-aware. Therefore, the returned List is of type
  /// [PersonalScore?].
  List<PersonalHighScore?> getAllPersonalHighScores() {
    final List<PersonalHighScore?> returnList = <PersonalHighScore?>[];
    for (int i = 0; i < _personalScoreBox.length; i++) {
      returnList.add(_personalScoreBox.getAt(i));
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
  List<UserState?> getAllCurrentActivities() {
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

  /// This method closes the database connection.
  void closeDatabase() {
    Hive.close();
    _databaseManagerInstance = null;
  }
}
