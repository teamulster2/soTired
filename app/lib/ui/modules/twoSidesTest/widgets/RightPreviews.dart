import 'package:flutter/material.dart';
import 'package:so_tired/ui/modules/twoSidesTest/widgets/PreviewContainer.dart';

class ArrowRightPrimary extends StatelessWidget {
  const ArrowRightPrimary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Preview(
        color: Theme.of(context).primaryColor, icon: true, quarterTurns: 0);
  }
}

class ArrowRightPrimaryLight extends StatelessWidget {
  const ArrowRightPrimaryLight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Preview(
        color: Theme.of(context).primaryColorLight,
        icon: true,
        quarterTurns: 0);
  }
}

class ArrowRightPrimaryDark extends StatelessWidget {
  const ArrowRightPrimaryDark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Preview(
        color: Theme.of(context).primaryColorDark, icon: true, quarterTurns: 0);
  }
}

class ArrowRightAccent extends StatelessWidget {
  const ArrowRightAccent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Preview(
        color: Theme.of(context).accentColor, icon: true, quarterTurns: 0);
  }
}
