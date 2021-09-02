import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ConfigUtils {
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
        jsonResponse.containsKey('isReactionGameEnabled') &&
        jsonResponse.containsKey('isQuestionnaireEnabled') &&
        jsonResponse.containsKey('isCurrentActivityEnabled') &&
        jsonResponse.containsKey('studyName') &&
        jsonResponse.containsKey('isStudy') &&
        jsonResponse.containsKey('question1') &&
        jsonResponse.containsKey('question2') &&
        jsonResponse.containsKey('question3') &&
        jsonResponse.containsKey('question4') &&
        jsonResponse.containsKey('question5');
  }

    static Future<String> getLocalFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName';
  }

  static Future<File> getConfigFileObject(String fileName) async {
    final configFilePath = await getLocalFilePath(fileName);
    if (!doesFileExist(configFilePath)) File(configFilePath).create();
    return File(configFilePath);
  }

  static bool doesFileExist(String filePath) {
    return File(filePath).existsSync();
  }
}
