import 'package:flutter/material.dart';

class CurrentEmotionalState extends StatelessWidget {
  const CurrentEmotionalState({required this.onTap, Key? key})
      : super(key: key);
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) => Container(
        height: (MediaQuery.of(context).size.height - 81) / 2.5,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Select your current emotional state: ',
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              EmotionalState(
                  onTap: () => onTap(1),
                  image: const AssetImage('assets/images/happy.png'),
                  text: 'happy'),
              const SizedBox(width: 30),
              EmotionalState(
                  onTap: () => onTap(2),
                  image: const AssetImage('assets/images/exiting.png'),
                  text: 'exciting'),
              const SizedBox(width: 30),
              EmotionalState(
                  onTap: () => onTap(3),
                  image: const AssetImage('assets/images/boring.png'),
                  text: 'boring'),
              const SizedBox(width: 30),
              EmotionalState(
                  onTap: () => onTap(4),
                  image: const AssetImage('assets/images/angry.png'),
                  text: 'sad'),
            ]),
          ],
        ));
}


class EmotionalState extends StatelessWidget {
  const EmotionalState(
      {required this.image, required this.text, required this.onTap, Key? key})
      : super(key: key);
  final AssetImage image;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Column(children: <Widget>[
        Image(image: image, width: 65, height: 65),
        const SizedBox(height: 5),
        Text(text, style: Theme.of(context).textTheme.bodyText2)
      ]));
}