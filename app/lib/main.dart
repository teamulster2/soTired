import 'package:flutter/material.dart';
import 'package:so_tired/config/config_manager.dart';
import 'package:so_tired/database/database_manager.dart';
import 'package:so_tired/config/config_manager.dart';
import 'package:so_tired/ui/core/home/home.dart';

import 'package:so_tired/notification.dart';
import 'package:timezone/data/latest.dart' as tz;

final ConfigManager configManager = ConfigManager();
final DatabaseManager databaseManager = DatabaseManager();
final Notifications notification = Notifications();

Future<void> main() async {
  runApp(const MyApp());

  await databaseManager.initDatabase();
  notification.initializeSetting();
  tz.initializeTimeZones();

  configManager.loadDefaultConfig();
  // TODO: Use this to initialize config
  // ConfigUtils.getLocalFilePath(_clientConfigFileName).then((value) {
  //   if (!ConfigUtils.doesFileExist(value)) {
  //     // TODO: invoke _fetchConfigFromServer()
  //     // or
  //     configManager.loadDefaultConfig();
  //     configManager.writeConfigToFile();
  //   } else {
  //     configManager.loadConfigFromJson();
  //   }
  // });
}

// TODO: Replace Demo App with real frontend and integrate config
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    notification.showScheduleNotification(
        configManager.clientConfig.notificationInterval,
        configManager.clientConfig.studyName,
        configManager.clientConfig.notificationText);
    return MaterialApp(
      title: 'soTired',
      theme: ThemeData(
          backgroundColor: const Color(0xff0B1C46),
          shadowColor: const Color(0xff071129),
          primaryColor: const Color(0xff97E8D9),
          accentColor: const Color(0xffD7AC94),
          primaryColorDark: const Color(0xff566A9F),
          primaryColorLight: const Color(0xffDF7CA6),
          fontFamily: 'Roboto',
          textTheme: const TextTheme(
            headline1: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Roboto'),
            headline2: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Roboto'),
            headline3: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Roboto'),
            bodyText1: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontFamily: 'Roboto'),
            bodyText2: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontFamily: 'Roboto'),
          )),
      home: const Home(),
    );
  }
}
