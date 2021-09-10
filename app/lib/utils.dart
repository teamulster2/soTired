import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:so_tired/config/client_config.dart';
import 'package:uuid/uuid.dart';

/// This calls serves as utility class. It contains only static methods which
/// enables you to use them without instantiating a new object.
class Utils {
  /// This method takes a [String clientConfigJsonString] and checks its
  /// compatibility to the [ClientConfig] class.
  static bool isClientConfigJsonValid(String clientConfigJsonString) {
    late final Map<String, dynamic> jsonResponse;
    // TODO: Discuss exception handling and adjust this part
    try {
      jsonResponse = jsonDecode(clientConfigJsonString);
    } catch (e) {
      return false;
    }

    // TODO: check specific keys when they're defined, e.g. is URL valid, ...
    return jsonResponse.containsKey('serverUrl') &&
        jsonResponse.containsKey('notificationInterval') &&
        jsonResponse.containsKey('notificationText') &&
        jsonResponse.containsKey('isSpatialSpanTaskEnabled') &&
        jsonResponse.containsKey('isMentalArithmeticEnabled') &&
        jsonResponse.containsKey('isPsychomotorVigilanceTaskEnabled') &&
        jsonResponse.containsKey('isQuestionnaireEnabled') &&
        jsonResponse.containsKey('isCurrentActivityEnabled') &&
        jsonResponse.containsKey('studyName') &&
        jsonResponse.containsKey('isStudy') &&
        jsonResponse.containsKey('questions');
  }

  /// This method uses the [dart:io] package to generate the local file path
  /// where files can be stored or read from.
  /// It takes [String fileName] as parameter and return a [Future<String>].
  static Future<String> getLocalFilePath(String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return Future<String>.value('${directory.path}/$fileName');
  }

  /// [getConfigFileObject] takes a [String fileName] as argument and returns
  /// an [File] pointing to the given fileName.
  static Future<File> getConfigFileObject(String fileName) async {
    final String configFilePath = await getLocalFilePath(fileName);
    if (!doesFileExist(configFilePath)) {
      File(configFilePath).createSync();
    }
    return Future<File>.value(File(configFilePath));
  }

  /// This methods validates whether or not a file exists.
  /// It takes [String filePath] as argument and returns a [bool].
  static bool doesFileExist(String filePath) => File(filePath).existsSync();

  /// This methods generates a random UUID.
  static String generateUuid() {
    const Uuid generator = Uuid();
    return generator.v4();
  }
}
