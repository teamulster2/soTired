import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:so_tired/utils/utils.dart';

void main() {
  group('Utils Basics', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      // NOTE: This has been copied from https://flutter.dev/docs/cookbook/persistence/reading-writing-files#testing
      // Create a temporary directory.
      final Directory directory = await Directory.systemTemp.createTemp();

      // Mock out the MethodChannel for the path_provider plugin.
      const MethodChannel('plugins.flutter.io/path_provider')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        // If you're getting the apps documents directory, return the path to the
        // temp directory on the test environment instead.
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return directory.path;
        }
        return null;
      });
    });

    test('localBasePath should match every time', () async {
      final String assertDirectoryPath =
          (await getApplicationDocumentsDirectory()).path;
      final String utilsDirectoryPath = await Utils.getLocalBasePath();

      expect(assertDirectoryPath, utilsDirectoryPath);
    });

    test('localFilePath should match every time when given the same argument',
            () async {
          const String assertDir = 'testDir';
          final String assertDirectoryPath =
              (await getApplicationDocumentsDirectory()).path + '/$assertDir';
          final String utilsDirectoryPath = await Utils.getLocalFilePath(
              assertDir);

          expect(assertDirectoryPath, utilsDirectoryPath);
        });

    test('localFilePath should not match when given different arguments',
            () async {
          final String assertDirectoryPath =
              (await getApplicationDocumentsDirectory()).path + '/test';
          final String utilsDirectoryPath = await Utils.getLocalFilePath(
              'testDir');

          expect(assertDirectoryPath, isNot(utilsDirectoryPath));
        });

    test('FileObject should match every time when given the same argument',
            () async {
          const String assertDir = 'testDir';
          final String assertDirectoryPath =
              (await getApplicationDocumentsDirectory()).path + '/$assertDir';
          final File assertDirectoryFile = File(assertDirectoryPath);
          final File utilsDirectoryFile = await Utils.getFileObject(assertDir);

          expect(assertDirectoryFile.path, utilsDirectoryFile.path);
        });

    test('FileObject should not match when given different arguments',
            () async {
          final String assertDirectoryPath =
              (await getApplicationDocumentsDirectory()).path + '/test';
          final File assertDirectoryFile = File(assertDirectoryPath);
          final File utilsDirectoryFile = await Utils.getFileObject('testDir');

          expect(assertDirectoryFile.path, isNot(utilsDirectoryFile.path));
        });

    test('files should exists when being created beforehand', () async {
      const String assertDir = 'testDir';
      final String assertDirectoryPath =
          (await getApplicationDocumentsDirectory()).path + '/$assertDir';
      await File(assertDirectoryPath).create();

      expect(Utils.doesFileExist(assertDirectoryPath), true);
    });

    test('files should not exist by default', () async {
      const String assertDir = 'testDir';
      final String assertDirectoryPath =
          (await getApplicationDocumentsDirectory()).path + '/$assertDir';

      expect(Utils.doesFileExist(assertDirectoryPath), true);
    });

    test('generated v4 UUIDs should match specific format', () {
      const String assertUuid = 'xxxxxxxx-xxxx-4xxx-zxxx-xxxxxxxxxxxx';

      expect(assertUuid.length, Utils
          .generateUuid()
          .length);
    });

    test('strings should be converted to code units', () {
      const String assertEmoji = '🤩';
      final List<int> assertList = <int>[
        int.parse('F0', radix: 16),
        int.parse('9F', radix: 16),
        int.parse('A4', radix: 16),
        int.parse('A9', radix: 16)
      ];

      expect(assertList, Utils.stringToCodeUnits(assertEmoji));
    });

    test('code units should be converted to string', () {
      const String assertEmoji = '🤩';
      final List<int> assertList = <int>[
        int.parse('F0', radix: 16),
        int.parse('9F', radix: 16),
        int.parse('A4', radix: 16),
        int.parse('A9', radix: 16)
      ];

      expect(assertEmoji, Utils.codeUnitsToString(assertList));
    });

    test('malformed code unit lists should throw a FormatException', () {
      final List<int> assertList = <int>[
        int.parse('F0', radix: 16)
      ];

      throwsA(() => Utils.codeUnitsToString(assertList));
    });
  });
}
