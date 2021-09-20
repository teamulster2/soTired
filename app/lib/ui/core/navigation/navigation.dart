import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({required this.title, Key? key}) : super(key: key);

  final String title;

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light));
  }

  @override
  Widget build(BuildContext context) => AppBar(
        title: Text(widget.title, style: Theme.of(context).textTheme.headline3),
        backgroundColor: Theme.of(context).backgroundColor,
        automaticallyImplyLeading: false,
        // NOTE: drawer not needed now
        /*leading: GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: const Icon(
            Icons.menu,
          ),
        ),*/
      );
}
