import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_tired/service_provider/service_provider.dart';
import 'package:so_tired/ui/core/home/widgets/home_button.dart';
import 'package:so_tired/ui/core/home/widgets/home_image.dart';
import 'package:so_tired/ui/core/navigation/navigation.dart';
import 'package:so_tired/ui/modules/questionnaire/questionnaire.dart';
import 'package:so_tired/ui/modules/self_test_engine/self_test.dart';
import 'package:so_tired/ui/modules/settings/settings.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

/// This class holds the home screen of the application. It contains a [Scaffold] that has its appBar, drawer and body.
/// The body contains the [HomeImage] and [HomeButton]s.
class _HomeState extends State<Home> {
  bool serverUrlTested = false;

  @override
  Widget build(BuildContext context) {
    if (!serverUrlTested) {
      testServerUrl();
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: NavigationBar(title: 'soTired'),
        ),
        // NOTE: drawer not needed now
        // drawer: const NavigationDrawer(),
        body: Container(
            color: Theme.of(context).backgroundColor,
            child: Column(children: <Widget>[
              const HomeImage(),
              const SizedBox(height: 40),
              Expanded(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 1.4,
                        children: <Widget>[
                          // NOTE: Icons from: https://api.flutter.dev/flutter/material/Icons-class.html
                          HomeButton(
                            icon: Icons.access_time_filled,
                            text: 'self test',
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<BuildContext>(
                                      builder: (BuildContext context) =>
                                          const SelfTest()));
                            },
                          ),
                          HomeButton(
                            icon: Icons.question_answer_rounded,
                            text: 'questionnaire',
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<BuildContext>(
                                      builder: (BuildContext context) =>
                                          const Questionnaire()));
                            },
                          ),
                          HomeButton(
                            icon: Icons.app_settings_alt,
                            text: 'settings',
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute<BuildContext>(
                                      builder: (BuildContext context) {
                                try {
                                  return const Settings();
                                } catch (e) {
                                  rethrow;
                                }
                              }));
                            },
                          ),
                          HomeButton(
                            icon: Icons.graphic_eq,
                            text: 'audio recognition',
                            onTap: () {
                              showAudioNotImplementedDialog();
                            },
                          ),
                        ])),
              ),
            ])));
  }

  void showAudioNotImplementedDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: const Text(
                    'Unfortunately the audio recognition has not been implemented yet.'),
                content: const Text('We will focus on that later on.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ]));
  }

  showInfoDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: const Text('You are not connected to a server.'),
                content: const Text(
                    'Please enter the server url in the settings page, you are forwarded to.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute<BuildContext>(
                              builder: (BuildContext context) =>
                                  const Settings()));
                    },
                  )
                ]));
  }

  testServerUrl() {
    serverUrlTested = true;
    try {
      final String? serverUrl =
          Provider.of<ServiceProvider>(context, listen: false)
              .databaseManager
              .getSettings()
              .serverUrl;
      debugPrint(serverUrl);
    } catch (exception) {
      Future<dynamic>.delayed(Duration.zero, () {
        showInfoDialog();
      });
    }
  }
}
