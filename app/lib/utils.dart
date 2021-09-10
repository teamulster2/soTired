import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// This calls serves as utility class. It contains only static methods which
/// enables you to use them without instantiating a new object.
class Utils {
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

  static String codeUnitsToString(List<int> codeUnits) {
    try {
      const Utf8Decoder utf8decoder = Utf8Decoder();
      return utf8decoder.convert(codeUnits);
    } on FormatException {
      throw const FormatException('The given List can not be converted into a '
          'valid UTF-8 String.');
    }
  }

  static List<int> stringToCodeUnits(String utf8) {
    const Utf8Encoder utf8encoder = Utf8Encoder();
    return utf8encoder.convert(utf8);
  }
}
