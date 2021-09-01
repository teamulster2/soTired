import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({Key? key}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 25.0, top: 25.0, right: 25.0),
      width: MediaQuery.of(context).size.width,
      height: 90,
      color: Theme.of(context).shadowColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('soTired', style: Theme.of(context).textTheme.headline3),
          Icon(Icons.menu, color: Colors.white),
        ]
      )
    );
  }
}
