import 'package:flutter/material.dart';

class Preview extends StatelessWidget {
  const Preview(
      {Key? key,
        required this.color,
        required this.icon,
        required this.quarterTurns})
      : super(key: key);

  final Color color;
  final bool icon;
  final int quarterTurns;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 120,
        height: 120,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
            color: Theme.of(context)
                .backgroundColor, //new Color.fromRGBO(255, 0, 0, 0.0),
            borderRadius: new BorderRadius.all(Radius.circular(20.0))),
        child: Container(
          decoration: new BoxDecoration(
              color: color, //new Color.fromRGBO(255, 0, 0, 0.0),
              borderRadius: new BorderRadius.all(Radius.circular(13.0))),
          width: 100,
          height: 100,
          child: showIcon(context, icon, quarterTurns),
        ));
  }

  Widget showIcon(BuildContext context, bool icon, int quarterTurns) {
    if (icon) {
      return RotatedBox(
          quarterTurns: quarterTurns,
          child: Icon(Icons.double_arrow_rounded,
              color: Theme.of(context).backgroundColor, size: 52));
    } else {
      return Container();
    }
  }
}