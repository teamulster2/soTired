import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: Container(
      color: Theme.of(context).backgroundColor,
      child: ListView(
        padding: const EdgeInsets.only(top: 40.0),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            child:
                Text('soTired', style: Theme.of(context).textTheme.headline3),
          ),
          ListTile(
            leading: const Icon(
              Icons.input,
              color: Colors.white,
            ),
            title: Text('Home', style: Theme.of(context).textTheme.bodyText1),
            onTap: () => {},
          ),
          ListTile(
            leading: const Icon(Icons.verified_user, color: Colors.white),
            title:
                Text('Profile', style: Theme.of(context).textTheme.bodyText1),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title:
                Text('Settings', style: Theme.of(context).textTheme.bodyText1),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.border_color, color: Colors.white),
            title:
                Text('Feedback', style: Theme.of(context).textTheme.bodyText1),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.white),
            title: Text('Logout', style: Theme.of(context).textTheme.bodyText1),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    ));
}
