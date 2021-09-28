import 'package:flutter/material.dart';
import 'package:so_tired/utils/utils.dart';

/// This widget sets the current activity of the subject.
/// It returns a [String] with the onTap Function().
class CurrentActivity extends StatelessWidget {
  const CurrentActivity({required this.onTap, Key? key}) : super(key: key);
  final Function(List<int>) onTap;

  @override
  Widget build(BuildContext context) => Container(
      height: (MediaQuery.of(context).size.height - 81) / 2,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Select your current activity: ',
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Activity(
                onTap: () => onTap(<int>[0xF0, 0x9F, 0x8F, 0xA1]),
                text: 'home',
                emoji: const <int>[0xF0, 0x9F, 0x8F, 0xA1]),
            const SizedBox(width: 40),
            Activity(
                onTap: () => onTap(<int>[0xE2, 0x98, 0x95]),
                text: 'work',
                emoji: const <int>[0xE2, 0x98, 0x95]),
            const SizedBox(width: 40),
            Activity(
                onTap: () => onTap(<int>[0xF0, 0x9F, 0x8F, 0xAB]),
                text: 'university',
                emoji: const <int>[0xF0, 0x9F, 0x8F, 0xAB]),
          ]),
          const SizedBox(height: 40),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Activity(
                onTap: () => onTap(<int>[0xF0, 0x9F, 0x9B, 0x8D]),
                text: 'shops',
                emoji: const <int>[0xF0, 0x9F, 0x9B, 0x8D]),
            const SizedBox(width: 40),
            Activity(
                onTap: () => onTap(<int>[
                      0xF0,
                      0x9F,
                      0x91,
                      0xA8,
                      0xE2,
                      0x80,
                      0x8D,
                      0xF0,
                      0x9F,
                      0x91,
                      0xA9,
                      0xE2,
                      0x80,
                      0x8D,
                      0xF0,
                      0x9F,
                      0x91,
                      0xA7,
                      0xE2,
                      0x80,
                      0x8D,
                      0xF0,
                      0x9F,
                      0x91,
                      0xA6
                    ]),
                text: 'friends / family',
                emoji: const <int>[
                  0xF0,
                  0x9F,
                  0x91,
                  0xA8,
                  0xE2,
                  0x80,
                  0x8D,
                  0xF0,
                  0x9F,
                  0x91,
                  0xA9,
                  0xE2,
                  0x80,
                  0x8D,
                  0xF0,
                  0x9F,
                  0x91,
                  0xA7,
                  0xE2,
                  0x80,
                  0x8D,
                  0xF0,
                  0x9F,
                  0x91,
                  0xA6
                ]),
            const SizedBox(width: 40),
            Activity(
                onTap: () => onTap(<int>[0xE2, 0x9B, 0xB3, 0xEF, 0xB8, 0x8F]),
                text: 'other',
                emoji: const <int>[0xE2, 0x9B, 0xB3, 0xEF, 0xB8, 0x8F]),
          ]),
        ],
      ));
}

/// This class contains the current activity ui part.
class Activity extends StatelessWidget {
  const Activity(
      {required this.emoji, required this.text, required this.onTap, Key? key})
      : super(key: key);
  final String text;
  final VoidCallback onTap;
  final List<int> emoji;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: onTap,
      child: Column(children: <Widget>[
        // Icon(icon, color: Theme.of(context).primaryColor, size: 50),
        Text(Utils.codeUnitsToString(emoji),
            style: Theme.of(context).textTheme.headline2),
        const SizedBox(height: 10),
        Text(text, style: Theme.of(context).textTheme.bodyText2)
      ]));
}
