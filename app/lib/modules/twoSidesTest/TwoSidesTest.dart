import 'dart:math';
import 'package:flutter/material.dart';
import 'package:so_tired/core/home/Home.dart';
import 'package:so_tired/core/navigation/Navigation.dart';
import 'package:so_tired/core/navigation/NavigationDrawer.dart';
import 'package:so_tired/modules/twoSidesTest/widgets/DownPreviews.dart';
import 'package:so_tired/modules/twoSidesTest/widgets/LeftPreviews.dart';
import 'package:so_tired/modules/twoSidesTest/widgets/PlainPreviews.dart';
import 'package:so_tired/modules/twoSidesTest/widgets/RightPreviews.dart';
import 'package:so_tired/modules/twoSidesTest/widgets/UpPreviews.dart';

class TwoSidesTest extends StatefulWidget {
  const TwoSidesTest({Key? key}) : super(key: key);

  @override
  _TwoSidesTestState createState() => _TwoSidesTestState();
}

class _TwoSidesTestState extends State<TwoSidesTest> {
  int expectedValue = 0;
  int score = 0;

  int next(int min, int max) => min + new Random().nextInt(max - min);
  ValueNotifier currentValue = new ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: NavigationBar(),
        ),
        drawer: NavigationDrawer(),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: getGameColumn()),
            ValueListenableBuilder(
                valueListenable: currentValue,
                builder: (context, value, child) {
                  return getArrow(currentValue.value);
                }),
          ],
        ));
  }

  Widget getGameRow() {
    return Row(
      children: [
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
              color: Theme.of(context).accentColor,
            ),
            onTap: () => detectTap(1)),
      ],
    );
  }

  Widget getGameColumn() {
    return Column(
      children: [
        Container(
            height: 200,
            child: Column(children: [
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
        Container(
            height: MediaQuery.of(context).size.height - 400 - 81,
            child: getGameRow()),
        Container(
            height: 200,
            child: Column(children: [
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
  }

  Widget getArrow(int currentValue) {
    switch (currentValue) {
      case 0:
        expectedValue = 0;
        return ArrowLeftPrimary();
      case 1:
        expectedValue = 0;
        return ArrowLeftPrimaryLight();
      case 2:
        expectedValue = 0;
        return ArrowLeftPrimaryDark();
      case 3:
        expectedValue = 0;
        return ArrowLeftAccent();
      case 4:
        expectedValue = 0;
        return PlainPrimary();

      case 5:
        expectedValue = 1;
        return ArrowRightPrimary();
      case 6:
        expectedValue = 1;
        return ArrowRightPrimaryLight();
      case 7:
        expectedValue = 1;
        return ArrowRightPrimaryDark();
      case 8:
        expectedValue = 1;
        return ArrowRightAccent();
      case 9:
        expectedValue = 1;
        return PlainAccent();

      case 10:
        expectedValue = 2;
        return ArrowUpPrimary();
      case 11:
        expectedValue = 2;
        return ArrowUpPrimaryLight();
      case 12:
        expectedValue = 2;
        return ArrowUpPrimaryDark();
      case 13:
        expectedValue = 2;
        return ArrowUpAccent();
      case 14:
        expectedValue = 3;
        return PlainPrimaryDark();

      case 15:
        expectedValue = 3;
        return ArrowDownPrimary();
      case 16:
        expectedValue = 3;
        return ArrowDownPrimaryLight();
      case 17:
        expectedValue = 3;
        return ArrowDownPrimaryDark();
      case 18:
        expectedValue = 3;
        return ArrowDownAccent();
      case 19:
        expectedValue = 2;
        return PlainPrimaryLight();

      default:
        return PlainPrimaryLight();
    }
  }

  detectTap(int val) {
    print('value ' + val.toString());
    print('expectedValue ' + expectedValue.toString());
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
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Game lost...'),
              content: Text('You have tapped the wrong side. Your score: ' +
                  score.toString()),
              actions: [
                TextButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home())),
                )
              ]);
        });
  }

  showStartDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Start Game'),
              content: Text('When you tap on "OK" the timer will start.' +
                  score.toString()),
              actions: [
                TextButton(
                  child: Text('Ok'),
                  onPressed: () => print('start'),
                )
              ]);
        });
  }
}
