import 'package:flutter/material.dart';

/// This widget shows the pvt square itself. The square is shown in the primary color of the app and is aligned in the center of the screen.
class PsychomotorVigilanceTaskSquare extends StatelessWidget {
  const PsychomotorVigilanceTaskSquare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
      height: 120,
      width: 120,
      color: Theme.of(context).primaryColor,
      alignment: Alignment.center,
      child: Text('Tap now!', style: Theme.of(context).textTheme.bodyText1));
}
