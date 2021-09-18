import 'package:flutter/material.dart';
import 'package:so_tired/ui/core/navigation/navigation.dart';
import 'package:so_tired/ui/core/widgets/classic_button.dart';

/// This widget holds all Setting parts of the application.
class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: NavigationBar(),
      ),
      // NOTE: drawer not needed now
      // drawer: const NavigationDrawer(),
      body: Container(
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 50),
              getChangeUrlPart(),
              const SizedBox(height: 50),
              const Divider(
                height: 20,
                thickness: 3,
                indent: 20,
                endIndent: 20,
                color: Colors.white,
              ),
              const SizedBox(height: 50),
              getSynchronizationPart(),
            ],
          )));

  void showInfoDialog(String title, String content) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: Text(title),
                content: Text(content),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ]));
  }

  Widget getChangeUrlPart() => Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      color: Theme.of(context).primaryColorDark.withOpacity(0.2),
      child: Column(children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Text('Change research url: ',
              style: Theme.of(context).textTheme.headline3),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: TextField(
            controller: myController,
            decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                hintText: 'Enter a url, e.g. http://www.example.com:50000'),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ClassicButton(
              color: Theme.of(context).primaryColor,
              buttonText: 'Save',
              onPressed: () {
                final String url = myController.text;

                if (_isUrlValid(url)) {
                  // TODO: ping server
                  // if (_isServerReachable) {
                  //   Provider.of<ServiceProvider>(context, listen: false)
                  //       .databaseManager.writeSettings(SettingsObject(url));
                  //   showInfoDialog('Successfully connected to server',
                  //       'This url wil be stored and is active now.');
                  // } else {
                  //   showInfoDialog('Could not connect to server',
                  //       'Please check your network connection and try again');
                  // }
                } else {
                  showInfoDialog(
                      'URL is invalid',
                      'Please enter a valid URL.\n'
                          'For example:\n'
                          'http://www.example.com:50000 or '
                          'http://192.168.178.20:60000');
                }
              },
            ),
          ],
        ),
      ]));

  Widget getSynchronizationPart() => Container(
        color: Theme.of(context).primaryColorDark.withOpacity(0.2),
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Text('Synchronization: ',
                  style: Theme.of(context).textTheme.headline3),
            ),
            const SizedBox(height: 20),
            ClassicButton(
              color: Theme.of(context).primaryColor,
              buttonText: 'Sync test results to database',
              onPressed: () {
                // TODO: Add method to sync test results to database
              },
            ),
          ],
        ),
      );

  bool _isUrlValid(String url) => Uri.parse(url).isAbsolute;
}
