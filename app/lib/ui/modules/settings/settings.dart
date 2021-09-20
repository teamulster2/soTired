import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_tired/api/client.dart';
import 'package:so_tired/database/models/settings/settings_object.dart';
import 'package:so_tired/exceptions/exceptions.dart';
import 'package:so_tired/service_provider/service_provider.dart';
import 'package:so_tired/ui/core/navigation/navigation.dart';
import 'package:so_tired/ui/core/widgets/classic_button.dart';
import 'package:so_tired/utils/utils.dart';

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
        child: NavigationBar(title: 'Settings'),
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
              onPressed: () async {
                final String url = myController.text;

                if (_isUrlValid(url)) {
                  _showCircularProgressIndicator(
                      'Checking server connection...',
                      'This may take a while.');
                  await validateServerConnection(() {
                    Provider.of<ServiceProvider>(context, listen: false)
                        .databaseManager
                        .writeSettings(SettingsObject(url));
                    Navigator.pop(context);
                    _showInfoDialog('Successfully connected to server',
                        'This URL will be stored and is active now.');
                  }, () {
                    Navigator.pop(context);
                    _showExceptionDialog(
                        'Could not connect to server',
                        "Please check your network connection and verify "
                            "you've entered the correct study URL.");
                  }, url);
                } else {
                  _showExceptionDialog(
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
              child: Text('Send test results to database',
                  style: Theme.of(context).textTheme.headline3),
            ),
            const SizedBox(height: 20),
            ClassicButton(
              color: Theme.of(context).primaryColor,
              buttonText: 'Send',
              onPressed: () {
                try {
                  Utils.sendDataToDatabase(context);
                } on EmptyHiveBoxException catch (e) {
                  _showExceptionDialog('URL can not be found!', e.msg);
                } on HttpErrorCodeException catch (e) {
                  _showExceptionDialog('Results could not be sent!', e.msg);
                } catch (e) {
                  // TODO: add proper exception handling
                }
              },
            ),
          ],
        ),
      );

  bool _isUrlValid(String url) =>
      Uri.parse(url).isAbsolute && !url.endsWith('/');

  void _showInfoDialog(String title, String content) {
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

  void _showCircularProgressIndicator(String title, String content) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: SizedBox(
                height: 85,
                child: Column(
                  children: <Widget>[
                    Text(content),
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: 60,
                      height: 60,
                      child: const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xff97E8D9))),
                    )
                  ],
                ))));
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
