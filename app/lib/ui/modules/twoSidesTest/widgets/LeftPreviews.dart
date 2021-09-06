import 'package:flutter/material.dart';
import 'package:so_tired/ui/modules/twoSidesTest/widgets/PreviewContainer.dart';

class ArrowLeftPrimary extends StatelessWidget {
  const ArrowLeftPrimary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Preview(
        color: Theme.of(context).primaryColor, icon: true, quarterTurns: 2);
  }
}

class ArrowLeftPrimaryLight extends StatelessWidget {
  const ArrowLeftPrimaryLight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Preview(
        color: Theme.of(context).primaryColorLight,
        icon: true,
        quarterTurns: 2);
  }
}

class ArrowLeftPrimaryDark extends StatelessWidget {
  const ArrowLeftPrimaryDark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Preview(
        color: Theme.of(context).primaryColorDark, icon: true, quarterTurns: 2);
  }
}

class ArrowLeftAccent extends StatelessWidget {
  const ArrowLeftAccent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Preview(
        color: Theme.of(context).accentColor, icon: true, quarterTurns: 2);
  }
}
