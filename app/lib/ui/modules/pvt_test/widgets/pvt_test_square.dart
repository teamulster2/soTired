import 'package:flutter/material.dart';

class PVTTestSquare extends StatelessWidget {
  const PVTTestSquare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
      height: 120,
      width: 120,
      color: Theme.of(context).primaryColor,
      alignment: Alignment.center,
      child: Text('Tap now!', style: Theme.of(context).textTheme.bodyText1));
}
