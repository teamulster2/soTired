import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:so_tired/utils.dart';

class DatabaseManager {
  static final DatabaseManager _databaseManagerInstance =
  DatabaseManager._databaseManager();

  // TODO: Adjust Box types based on HiveObjects
  late final Box<dynamic> personalScoresBox;
  late final Box<dynamic> userLogBox;
  late final Box<dynamic> currentActivityBox;
  late final Box<dynamic> questionnaireResultBox;

  final Logger _logger = Logger(
    printer: PrettyPrinter(),
  );

  DatabaseManager._databaseManager() {
    Utils.getLocalFilePath('database')
        .then((String value) async {
      Hive.init(value);
      _logger.i('database has been set up successfully!');
      personalScoresBox = await Hive.openBox('personalScoresBox');
      userLogBox = await Hive.openBox('userLogBox');
      currentActivityBox = await Hive.openBox('currentActivityBox');
      questionnaireResultBox = await Hive.openBox('questionnaireResultBox');
      _logger.i('boxes have been opened successfully');
    });
    // Completer<String>.sync().complete(databasePath);
    // _logger.d(databasePath.then((String value) => value));
    // Hive.init(databasePath.asStream().toString());
  }

  factory DatabaseManager() => _databaseManagerInstance;
}
