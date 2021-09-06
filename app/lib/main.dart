import 'package:flutter/material.dart';
import 'package:so_tired/ui/core/home/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'soTired',
      theme: ThemeData(
          backgroundColor: Color(0xff0B1C46),
          shadowColor: Color(0xff071129),
          primaryColor: Color(0xff97E8D9),
          accentColor: Color(0xffD7AC94),
          primaryColorDark: Color(0xff566A9F),
          primaryColorLight: Color(0xffDF7CA6),
          fontFamily: 'Roboto',
          textTheme: TextTheme(
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
      home: Home(),
    );
}
