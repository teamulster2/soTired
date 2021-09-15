import 'package:flutter/material.dart';

class PVTTestDiff extends StatelessWidget {
  const PVTTestDiff({required this.diff, Key? key}) : super(key: key);

  final String diff;

  @override
  Widget build(BuildContext context) =>
      Text(diff, style: Theme.of(context).textTheme.headline2);
}
