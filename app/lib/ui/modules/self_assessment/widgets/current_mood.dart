import 'package:flutter/material.dart';
import 'package:so_tired/utils/utils.dart';

/// This widget sets the current emotional state of the subject.
/// It returns a [List] with the onTap Function().
class CurrentMood extends StatelessWidget {
  const CurrentMood({required this.onTap, Key? key}) : super(key: key);
  final Function(List<String>) onTap;

  @override
  Widget build(BuildContext context) => Container(
      height: (MediaQuery.of(context).size.height - 81) / 2.5,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Select your current mood: ',
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            CurrentMoodState(
                onTap: () => onTap(<String>['happy']),
                text: 'happy',
                emoji: const <int>[0xF0, 0x9F, 0x98, 0x8A]),
            const SizedBox(width: 30),
            CurrentMoodState(
                onTap: () => onTap(<String>['excited']),
                text: 'excited',
                emoji: const <int>[0xF0, 0x9F, 0xA4, 0xA9]),
            const SizedBox(width: 30),
            CurrentMoodState(
                onTap: () => onTap(<String>['bored']),
                text: 'bored',
                emoji: const <int>[0xF0, 0x9F, 0x98, 0x90]),
            const SizedBox(width: 30),
            CurrentMoodState(
                onTap: () => onTap(<String>['sad']),
                text: 'sad',
                emoji: const <int>[0xF0, 0x9F, 0x98, 0xAD]),
          ]),
        ],
      ));
}

/// This widget shows the emotional states with its text.
class CurrentMoodState extends StatelessWidget {
  const CurrentMoodState(
      {required this.text, required this.onTap, required this.emoji, Key? key})
      : super(key: key);
  final String text;
  final VoidCallback onTap;
  final List<int> emoji;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Column(children: <Widget>[
        /*Image(image: image, width: 65, height: 65),*/
        Text(Utils.codeUnitsToString(emoji),
            style: Theme.of(context).textTheme.headline2),
        const SizedBox(height: 5),
        Text(text, style: Theme.of(context).textTheme.bodyText2)
      ]));
}
