import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:so_tired/database/models/current_activity.dart';
import 'package:so_tired/database/models/personal_scores.dart';
import 'package:so_tired/database/models/questionnaire_results.dart';
import 'package:so_tired/database/models/user/user_log.dart';
import 'package:so_tired/utils.dart';

class DatabaseManager {
  static final DatabaseManager _databaseManagerInstance =
      DatabaseManager._databaseManager();

  // TODO: Adjust Box types based on HiveObjects
  late final Box<PersonalScores> personalScoresBox;
  late final Box<UserLog> userLogBox;
  late final Box<CurrentActivity> currentActivityBox;
  late final Box<QuestionnaireResults> questionnaireResultBox;

  final Logger _logger = Logger(
    printer: PrettyPrinter(),
  );

  DatabaseManager._databaseManager();

  factory DatabaseManager() => _databaseManagerInstance;

  Future<void> initDatabase() async {
    final String databasePath = await Utils.getLocalFilePath('database');
    Hive.init(databasePath);
    _logger.i('database has been set up successfully!');
    personalScoresBox = await Hive.openBox('personalScoresBox');
    userLogBox = await Hive.openBox('userLogBox');
    currentActivityBox = await Hive.openBox('currentActivityBox');
    questionnaireResultBox = await Hive.openBox('questionnaireResultBox');
    _logger.i('boxes have been opened successfully');
  }
}
