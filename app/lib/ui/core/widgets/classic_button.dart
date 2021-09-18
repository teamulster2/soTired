import 'package:flutter/material.dart';

/// This widget provides the possibility to show a classic button with round edges in the whole application.
class ClassicButton extends StatelessWidget {
  const ClassicButton(
      {required this.onPressed,
      required this.color,
      required this.buttonText,
      Key? key})
      : super(key: key);
  final VoidCallback onPressed;
  final String buttonText;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        child: TextButton(
            child:
                Text(buttonText, style: Theme.of(context).textTheme.bodyText1),
            onPressed: () {
              onPressed();
            }),
        padding:
            const EdgeInsets.only(right: 7.5, left: 7.5, top: 5, bottom: 5),
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
      );
}
