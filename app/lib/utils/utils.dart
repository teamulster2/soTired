import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:so_tired/api/client.dart';
import 'package:so_tired/database/models/settings/settings_object.dart';
import 'package:so_tired/service_provider/service_provider.dart';
import 'package:uuid/uuid.dart';

/// This calls serves as utility class. It contains only static methods which
/// enables you to use them without instantiating a new object.
class Utils {
  /// This method returns the basePath where, for example both, client config
  /// and database boxes are stored.
  /// It takes no arguments and returns a [Future] of type [String].
  static Future<String> getLocalBasePath() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return Future<String>.value(directory.path);
  }

  /// This method uses the dart:io package to generate the local file path
  /// where files can be stored or read from.
  /// It takes [fileName] as parameter and return a [Future] of type [String].
  static Future<String> getLocalFilePath(String fileName) async =>
      Future<String>.value('${await getLocalBasePath()}/$fileName');

  /// [getFileObject] takes a [fileName] as argument and returns
  /// an [File] pointing to the given fileName.
  static Future<File> getFileObject(String fileName) async {
    final String configFilePath = await getLocalFilePath(fileName);
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

  /// This method takes [codeUnits] as [List] of type [int] and converts them
  /// into a [String].
  static String codeUnitsToString(List<int> codeUnits) {
    try {
      const Utf8Decoder utf8decoder = Utf8Decoder();
      return utf8decoder.convert(codeUnits);
    } on FormatException catch (e) {
      throw FormatException(
          'The given List can not be converted into a valid UTF-8 String.\n\n'
          'Initial error message:\n$e');
    }
  }

  /// This method takes a [String] and converts it into code units.
  static List<int> stringToCodeUnits(String utf8) {
    const Utf8Encoder utf8encoder = Utf8Encoder();
    return utf8encoder.convert(utf8);
  }

  /// This method is used to send the current database content to the server.
  /// It takes the [BuildContext] as argument to be able to get the
  /// [ServiceProvider].
  /// If the server export fails [Exception]s will be rethrown and need to be
  /// handled.
  static Future<void> sendDataToDatabase(BuildContext context) async {
    try {
      final SettingsObject _settings =
          Provider.of<ServiceProvider>(context, listen: false)
              .databaseManager
              .getSettings();
      if (_settings.serverUrl!.isNotEmpty) {
        await sendData(_settings.serverUrl!);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// This method returns the current version and build number of the app.
  static Future<String> getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.version}+${packageInfo.buildNumber}';
  }
}
