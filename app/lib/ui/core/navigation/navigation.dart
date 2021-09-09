import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({Key? key}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) => AppBar(
        title: Text('soTired', style: Theme.of(context).textTheme.headline3),
        backgroundColor: Theme.of(context).backgroundColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.light),
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: const Icon(
            Icons.menu,
          ),
        ),
      );
}
