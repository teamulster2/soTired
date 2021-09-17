import 'package:flutter/material.dart';

/// This widget shows the current pvt progress. So the user knows how many boxes he has to click and how many boxes he already clicked.
class PVTTestProgress extends StatefulWidget {
  const PVTTestProgress({required this.max, required this.counter, Key? key})
      : super(key: key);

  final int max;
  final int counter;

  @override
  _PVTTestProgressState createState() => _PVTTestProgressState();
}

class _PVTTestProgressState extends State<PVTTestProgress> {
  @override
  Widget build(BuildContext context) => Container(
        color: Theme.of(context).primaryColorDark.withOpacity(0.2),
        margin: const EdgeInsets.all(10),
        height: 150,
        width: 400,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Tap the box each time it appears.',
                style: Theme.of(context).textTheme.bodyText1),
            const SizedBox(height: 20),
            Text(
                'Box ' +
                    (widget.max - widget.counter).toString() +
                    ' of ' +
                    widget.max.toString(),
                style: Theme.of(context).textTheme.headline3),
          ],
        ),
      );
}
