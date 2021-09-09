import 'dart:math';
import 'package:flutter/material.dart';
import 'package:so_tired/ui/core/home/home.dart';
import 'package:so_tired/ui/core/navigation/navigation.dart';
import 'package:so_tired/ui/core/navigation/navigation_drawer.dart';
import 'package:so_tired/ui/modules/twoSidesTest/widgets/down_previews.dart';
import 'package:so_tired/ui/modules/twoSidesTest/widgets/left_previews.dart';
import 'package:so_tired/ui/modules/twoSidesTest/widgets/plain_previews.dart';
import 'package:so_tired/ui/modules/twoSidesTest/widgets/right_previews.dart';
import 'package:so_tired/ui/modules/twoSidesTest/widgets/up_previews.dart';

class TwoSidesTest extends StatefulWidget {
  const TwoSidesTest({Key? key}) : super(key: key);

  @override
  _TwoSidesTestState createState() => _TwoSidesTestState();
}

class _TwoSidesTestState extends State<TwoSidesTest> {
  int expectedValue = 0;
  int score = 0;

  int next(int min, int max) => min + Random().nextInt(max - min);
  ValueNotifier<int> currentValue = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: NavigationBar(),
      ),
      drawer: const NavigationDrawer(),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: getGameColumn()),
          ValueListenableBuilder<int>(
              valueListenable: currentValue,
              builder: (BuildContext context, int value, Widget? child) =>
                  getArrow(currentValue.value)),
        ],
      ));

  Widget getGameRow() => Row(
        children: <Widget>[
          GestureDetector(
              child: Container(
                width: MediaQuery.of(context).size.width / 2 - 10,
                height: MediaQuery.of(context).size.height,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () => detectTap(0)),
          Container(
            width: 20,
            height: MediaQuery.of(context).size.height,
            color: Theme.of(context).backgroundColor,
          ),
          GestureDetector(
              child: Container(
                width: MediaQuery.of(context).size.width / 2 - 10,
                height: MediaQuery.of(context).size.height,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onTap: () => detectTap(1)),
        ],
      );

  Widget getGameColumn() => Column(
        children: <Widget>[
          SizedBox(
              height: 200,
              child: Column(children: <Widget>[
                GestureDetector(
                  child: Container(
                    color: Theme.of(context).primaryColorDark,
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                  ),
                  onTap: () => detectTap(3),
                ),
                Container(
                  color: Theme.of(context).backgroundColor,
                  height: 20,
                  width: MediaQuery.of(context).size.width,
                )
              ])),
          SizedBox(
              height: MediaQuery.of(context).size.height - 400 - 81,
              child: getGameRow()),
          SizedBox(
              height: 200,
              child: Column(children: <Widget>[
                Container(
                  color: Theme.of(context).backgroundColor,
                  height: 20,
                  width: MediaQuery.of(context).size.width,
                ),
                GestureDetector(
                  child: Container(
                    color: Theme.of(context).primaryColorLight,
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                  ),
                  onTap: () => detectTap(2),
                ),
              ])),
        ],
      );

  Widget getArrow(int currentValue) {
    switch (currentValue) {
      case 0:
        expectedValue = 0;
        return const ArrowLeftPrimary();
      case 1:
        expectedValue = 0;
        return const ArrowLeftPrimaryLight();
      case 2:
        expectedValue = 0;
        return const ArrowLeftPrimaryDark();
      case 3:
        expectedValue = 0;
        return const ArrowLeftAccent();
      case 4:
        expectedValue = 0;
        return const PlainPrimary();

      case 5:
        expectedValue = 1;
        return const ArrowRightPrimary();
      case 6:
        expectedValue = 1;
        return const ArrowRightPrimaryLight();
      case 7:
        expectedValue = 1;
        return const ArrowRightPrimaryDark();
      case 8:
        expectedValue = 1;
        return const ArrowRightAccent();
      case 9:
        expectedValue = 1;
        return const PlainAccent();

      case 10:
        expectedValue = 2;
        return const ArrowUpPrimary();
      case 11:
        expectedValue = 2;
        return const ArrowUpPrimaryLight();
      case 12:
        expectedValue = 2;
        return const ArrowUpPrimaryDark();
      case 13:
        expectedValue = 2;
        return const ArrowUpAccent();
      case 14:
        expectedValue = 3;
        return const PlainPrimaryDark();

      case 15:
        expectedValue = 3;
        return const ArrowDownPrimary();
      case 16:
        expectedValue = 3;
        return const ArrowDownPrimaryLight();
      case 17:
        expectedValue = 3;
        return const ArrowDownPrimaryDark();
      case 18:
        expectedValue = 3;
        return const ArrowDownAccent();
      case 19:
        expectedValue = 2;
        return const PlainPrimaryLight();

      default:
        return const PlainPrimaryLight();
    }
  }

  detectTap(int val) {
    int newValue = next(0, 19);
    while (newValue == currentValue.value) {
      newValue = next(0, 19);
    }

    if (expectedValue == val) {
      score += 1;
      currentValue.value = newValue;
    } else {
      showADialog();
    }
  }

  showADialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: const Text('Game lost...'),
                content: Text('You have tapped the wrong side. Your score: ' +
                    score.toString()),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute<BuildContext>(
                            builder: (BuildContext context) => const Home())),
                  )
                ]));
  }

  showStartDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: const Text('Start Game'),
                content: Text('When you tap on "OK" the timer will start.' +
                    score.toString()),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {},
                  )
                ]));
  }
}
