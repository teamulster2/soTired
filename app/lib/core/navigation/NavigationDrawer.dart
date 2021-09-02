import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: Theme.of(context).backgroundColor,
      child: ListView(
        padding: EdgeInsets.only(top: 40.0),
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Text('soTired', style: Theme.of(context).textTheme.headline3),
          ),
          ListTile(
            leading: Icon(Icons.input, color: Colors.white,),
            title: Text('Home', style: Theme.of(context).textTheme.bodyText1),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.verified_user, color: Colors.white),
            title: Text('Profile', style: Theme.of(context).textTheme.bodyText1),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text('Settings', style: Theme.of(context).textTheme.bodyText1),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color, color: Colors.white),
            title: Text('Feedback', style: Theme.of(context).textTheme.bodyText1),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.white),
            title: Text('Logout', style: Theme.of(context).textTheme.bodyText1),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    ));
  }
}
