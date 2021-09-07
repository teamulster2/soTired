import 'package:hive_flutter/hive_flutter.dart';
import 'package:so_tired/database/models/activity/current_activity.dart';
import 'package:so_tired/database/models/questionnaire/questionnaire_result.dart';
import 'package:so_tired/database/models/score/personal_score.dart';
import 'package:so_tired/database/models/user/user_log.dart';
import 'package:so_tired/utils.dart';

class DatabaseManager {
  static final DatabaseManager _databaseManagerInstance =
      DatabaseManager._databaseManager();

  late final Box<PersonalScore> _personalScoreBox;
  late final Box<UserLog> _userLogBox;
  late final Box<CurrentActivity> _currentActivityBox;
  late final Box<QuestionnaireResult> _questionnaireResultBox;

  DatabaseManager._databaseManager();

  factory DatabaseManager() => _databaseManagerInstance;

  Future<void> initDatabase() async {
    final String databasePath = await Utils.getLocalFilePath('database');
    Hive.init(databasePath);

    // ignore: cascade_invocations
    Hive.registerAdapter(PersonalScoreAdapter());
    // ignore: cascade_invocations
    Hive.registerAdapter(UserLogAdapter());
    // ignore: cascade_invocations
    Hive.registerAdapter(CurrentActivityAdapter());
    // ignore: cascade_invocations
    Hive.registerAdapter(QuestionnaireResultAdapter());

    _personalScoreBox = await Hive.openBox('personalScoresBox');
    _userLogBox = await Hive.openBox('userLogBox');
    _currentActivityBox = await Hive.openBox('currentActivityBox');
    _questionnaireResultBox = await Hive.openBox('questionnaireResultBox');
  }

  Future<void> writePersonalScores(List<PersonalScore> scores) async =>
      _personalScoreBox.addAll(scores);

  Future<void> writeUserLogs(List<UserLog> logs) async =>
      _userLogBox.addAll(logs);

  Future<void> writeCurrentActivities(List<CurrentActivity> activities) async =>
      _currentActivityBox.addAll(activities);

  Future<void> writeQuestionnaireResults(
          List<QuestionnaireResult> results) async =>
      _questionnaireResultBox.addAll(results);

  PersonalScore? getPersonalScoreById(String uuid) =>
      _personalScoreBox.get(uuid);

  UserLog? getUserLogById(String uuid) => _userLogBox.get(uuid);

  CurrentActivity? getCurrentActivityById(String uuid) =>
      _currentActivityBox.get(uuid);

  QuestionnaireResult? getQuestionnaireResultById(String uuid) =>
      _questionnaireResultBox.get(uuid);

  List<PersonalScore?> getAllPersonalScores() {
    final List<PersonalScore?> returnList = <PersonalScore?>[];
    for (int i = 0; i < _personalScoreBox.length; i++) {
      returnList.add(_personalScoreBox.getAt(i));
    }
    return returnList;
  }

  List<UserLog?> getAllUserLogs() {
    final List<UserLog?> returnList = <UserLog?>[];
    for (int i = 0; i < _userLogBox.length; i++) {
      returnList.add(_userLogBox.getAt(i));
    }
    return returnList;
  }

  List<CurrentActivity?> getAllCurrentActivities() {
    final List<CurrentActivity?> returnList = <CurrentActivity?>[];
    for (int i = 0; i < _currentActivityBox.length; i++) {
      returnList.add(_currentActivityBox.getAt(i));
    }
    return returnList;
  }

  List<QuestionnaireResult?> getAllQuestionnaireResults() {
    final List<QuestionnaireResult?> returnList = <QuestionnaireResult?>[];
    for (int i = 0; i < _questionnaireResultBox.length; i++) {
      returnList.add(_questionnaireResultBox.getAt(i));
    }
    return returnList;
  }
}
