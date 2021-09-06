import 'package:flutter/material.dart';
import 'package:so_tired/ui/modules/twoSidesTest/widgets/preview_container.dart';

class PlainPrimary extends StatelessWidget {
  const PlainPrimary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Preview(
        color: Theme.of(context).primaryColor, icon: false, quarterTurns: 0);
}

class PlainPrimaryLight extends StatelessWidget {
  const PlainPrimaryLight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Preview(
        color: Theme.of(context).primaryColorLight,
        icon: false,
        quarterTurns: 0);
}

class PlainPrimaryDark extends StatelessWidget {
  const PlainPrimaryDark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Preview(
        color: Theme.of(context).primaryColorDark,
        icon: false,
        quarterTurns: 0);
}

class PlainAccent extends StatelessWidget {
  const PlainAccent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Preview(
        color: Theme.of(context).accentColor, icon: false, quarterTurns: 0);
}
