import 'package:flutter/material.dart';

/// This widget shows the difference between a pvt square shown and tapping the screen.
/// Time difference in milliseconds.
class PsychomotorVigilanceTaskDiff extends StatelessWidget {
  const PsychomotorVigilanceTaskDiff({required this.diff, Key? key})
      : super(key: key);

  final String diff;

  @override
  Widget build(BuildContext context) =>
      Text('$diff ms', style: Theme.of(context).textTheme.headline2);
}
