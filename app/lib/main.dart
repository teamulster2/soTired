import 'package:flutter/material.dart';
import 'core/home/Home.dart';

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
          fontFamily: 'Roboto',
          textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
            headline2: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            headline3: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            bodyText1: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.white),
            bodyText2: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          )

          //566A9F
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          ),
      home: Home(),
    );
}
