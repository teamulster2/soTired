import 'package:flutter/material.dart';
import 'package:so_tired/ui/modules/twoSidesTest/widgets/preview_container.dart';

class ArrowDownPrimary extends StatelessWidget {
  const ArrowDownPrimary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Preview(
      color: Theme.of(context).primaryColor, icon: true, quarterTurns: 3);
}

class ArrowDownPrimaryLight extends StatelessWidget {
  const ArrowDownPrimaryLight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Preview(
      color: Theme.of(context).primaryColorLight, icon: true, quarterTurns: 3);
}

class ArrowDownPrimaryDark extends StatelessWidget {
  const ArrowDownPrimaryDark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Preview(
      color: Theme.of(context).primaryColorDark, icon: true, quarterTurns: 3);
}

class ArrowDownAccent extends StatelessWidget {
  const ArrowDownAccent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Preview(
      color: Theme.of(context).colorScheme.secondary,
      icon: true,
      quarterTurns: 3);
}
