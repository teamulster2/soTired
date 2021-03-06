import 'package:flutter/material.dart';

class HomeButton extends StatefulWidget {
  const HomeButton(
      {required this.icon, required this.text, required this.onTap, Key? key})
      : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  _HomeButtonState createState() => _HomeButtonState();
}

/// This widget defines the home buttons on the home page of the app.
/// The variable 'icon' contains the [IconData] shown in primary color.
/// 'text' defines the text of the button.
/// 'onTap' contains the method with the functionality when you click the button.
class _HomeButtonState extends State<HomeButton> {
  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: widget.onTap,
      child: Column(children: <Widget>[
        Icon(widget.icon, color: Theme.of(context).primaryColor, size: 50),
        const SizedBox(height: 10),
        Text(widget.text, style: Theme.of(context).textTheme.bodyText2)
      ]));
}
