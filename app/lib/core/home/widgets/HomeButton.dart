import 'package:flutter/material.dart';

class HomeButton extends StatefulWidget {
  const HomeButton({Key? key, required this.icon, required this.text, required this.onTap}) : super(key: key);

  final int icon;
  final String text;
  final VoidCallback onTap;

  @override
  _HomeButtonState createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        children: [
          Icon(IconData(widget.icon, fontFamily: 'MaterialIcons'), color: Theme.of(context).primaryColor, size: 50),
          SizedBox(height: 10),
          Text(widget.text, style: Theme.of(context).textTheme.bodyText2)
        ]
      )
    );
  }
}
