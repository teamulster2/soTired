import 'package:flutter/material.dart';
import 'package:so_tired/ui/modules/twoSidesTest/widgets/preview_container.dart';

class ArrowUpPrimary extends StatelessWidget {
  const ArrowUpPrimary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Preview(
      color: Theme.of(context).primaryColor, icon: true, quarterTurns: 1);
}

class ArrowUpPrimaryLight extends StatelessWidget {
  const ArrowUpPrimaryLight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Preview(
      color: Theme.of(context).primaryColorLight, icon: true, quarterTurns: 1);
}

class ArrowUpPrimaryDark extends StatelessWidget {
  const ArrowUpPrimaryDark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Preview(
      color: Theme.of(context).primaryColorDark, icon: true, quarterTurns: 1);
}

class ArrowUpAccent extends StatelessWidget {
  const ArrowUpAccent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Preview(
      color: Theme.of(context).colorScheme.secondary, icon: true, quarterTurns: 1);
}
