import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_tired/services_provider.dart';
import 'package:so_tired/ui/core/home/home.dart';
import 'package:so_tired/notification.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // ignore: always_specify_types
  Widget build(BuildContext context) =>
      ChangeNotifierProvider(
        create: (BuildContext context) => ServicesProvider(),
        child: const MyAppContent(),
      );
}

// TODO: Rename classes appropriately
class MyAppContent extends StatefulWidget {
  const MyAppContent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyAppContent> with WidgetsBindingObserver {
  bool _doneInitializing = false;
  final Notifications notification = Notifications();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    Provider.of<ServicesProvider>(context, listen: false)
        .init(() => setState(() => _doneInitializing = true));
    notification.initializeSetting();
    tz.initializeTimeZones();
  }
}

@override
Widget build(BuildContext context) {
  notification.showScheduleNotification(
      configManager.clientConfig.notificationInterval,
      configManager.clientConfig.studyName,
      configManager.clientConfig.notificationText);
  )
  if (_doneInitializing) {
  return MaterialApp(
  title: 'soTired',
  theme: ThemeData(
  backgroundColor: const Color(0xff0B1C46),
  shadowColor: const Color(0xff071129),
  primaryColor: const Color(0xff97E8D9),
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
  ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xffD7AC94))),
  home: const Home(),
  );
  } else {
  return const CircularProgressIndicator();
  }
}

@override
void dispose() {
  super.dispose();
  WidgetsBinding.instance?.removeObserver(this);

  Provider
      .of<ServicesProvider>(context, listen: false)
      .databaseManager
      .closeDatabase();
}}
