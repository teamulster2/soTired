import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:so_tired/exceptions/exceptions.dart';
import 'package:so_tired/service_provider/service_provider.dart';
import 'package:so_tired/ui/core/home/home.dart';
import 'package:so_tired/utils/utils.dart';

Future<void> main() async => runApp(const SoTiredApp());

class SoTiredApp extends StatelessWidget {
  const SoTiredApp({Key? key}) : super(key: key);

  @override
  // ignore: always_specify_types
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        <DeviceOrientation>[DeviceOrientation.portraitUp]);
    // ignore: always_specify_types, NOTE: endless loop when specifying
    return ChangeNotifierProvider(
      create: (BuildContext context) => ServiceProvider(),
      child: const SoTiredAppContent(),
    );
  }
}

class SoTiredAppContent extends StatefulWidget {
  const SoTiredAppContent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SoTiredAppState();
}

class SoTiredAppState extends State<SoTiredAppContent>
    with WidgetsBindingObserver {
  bool _doneInitializing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    Utils.getLocalBasePath().then((String path) {
      try {
        Provider.of<ServiceProvider>(context, listen: false)
            .init(() => setState(() => _doneInitializing = true), path);
      } on BaseException catch (e) {
        _showExceptionDialog('Something went wrong!', e.msg);
      } catch (e) {
        _showExceptionDialog(
            'Something went wrong!',
            'Critical app error. '
                'Please restart your application! '
                'If your problem still consists, please contact the study '
                'administrators for further advice.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            ),
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: const Color(0xffD7AC94))),
        home: const Home(),
      );
    } else {
      return Container(
          alignment: Alignment.center,
          child: const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Color(0xff97E8D9)))));
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);

    Provider.of<ServiceProvider>(context, listen: false)
        .databaseManager
        .closeDatabase();
  }

  void _showExceptionDialog(String title, String content) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
                backgroundColor: Theme.of(context).primaryColorLight,
                title: Text(title),
                content: Text(content),
                actions: <Widget>[
                  TextButton(
                      child: const Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ]));
  }
}
