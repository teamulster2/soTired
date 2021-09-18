import 'package:flutter/material.dart';
import 'package:so_tired/ui/core/navigation/navigation.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: NavigationBar(),
      ),
      // NOTE: drawer not needed now
      // drawer: const NavigationDrawer(),
      body: Container(
        color: Theme.of(context).backgroundColor,
      ));
}
