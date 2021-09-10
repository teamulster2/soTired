import 'package:flutter/material.dart';
import 'package:so_tired/ui/modules/twoSidesTest/widgets/preview_container.dart';

class ArrowLeftPrimary extends StatelessWidget {
  const ArrowLeftPrimary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Preview(
      color: Theme.of(context).primaryColor, icon: true, quarterTurns: 2);
}

class ArrowLeftPrimaryLight extends StatelessWidget {
  const ArrowLeftPrimaryLight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Preview(
      color: Theme.of(context).primaryColorLight, icon: true, quarterTurns: 2);
}

class ArrowLeftPrimaryDark extends StatelessWidget {
  const ArrowLeftPrimaryDark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Preview(
      color: Theme.of(context).primaryColorDark, icon: true, quarterTurns: 2);
}

class ArrowLeftAccent extends StatelessWidget {
  const ArrowLeftAccent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Preview(
      color: Theme.of(context).colorScheme.secondary,
      icon: true,
      quarterTurns: 2);
}
