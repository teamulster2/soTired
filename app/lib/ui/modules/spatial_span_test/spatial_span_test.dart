import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:so_tired/ui/core/navigation/navigation.dart';
import 'package:so_tired/ui/core/navigation/navigation_drawer.dart';
import 'package:so_tired/ui/modules/spatial_span_test/widgets/spatial_span_test_box.dart';

class SpatialSpanTest extends StatefulWidget {
  const SpatialSpanTest({Key? key}) : super(key: key);

  @override
  _SpatialSpanTestState createState() => _SpatialSpanTestState();
}

class _SpatialSpanTestState extends State<SpatialSpanTest> {
  final ValueNotifier<int> currentPrimary = ValueNotifier<int>(0);

  int next(int min, int max) => min + Random().nextInt(max - min);
  int i = 0;
  GameState currentGameState = GameState.start;

  List<int> currentSequence = <int>[];

  @override
  Widget build(BuildContext context) {
    Future<dynamic>.delayed(Duration.zero, () => showStartDialog());

    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: NavigationBar(),
        ),
        drawer: const NavigationDrawer(),
        body: Container(
            color: Theme.of(context).backgroundColor,
            child: Column(
              children: <Widget>[
                TextButton(
                    onPressed: () => startSequence(),
                    child: Text('Start',
                        style: Theme.of(context).textTheme.bodyText1)),
                SizedBox(
                    height: MediaQuery.of(context).size.height - 129,
                    width: MediaQuery.of(context).size.width,
                    child: GridView.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: <Widget>[
                        for (int i = 1; i < 17; i++)
                          ValueListenableBuilder<int>(
                              valueListenable: currentPrimary,
                              builder: (BuildContext context, Object? value,
                                      Widget? widget) =>
                                  SpatialSpanTestBox(
                                      primary: i == currentPrimary.value,
                                      onTap: () => checkTappedBox(i)))
                      ],
                    )),
              ],
            )));
  }

  List<int> getSequence(int length) {
    final List<int> values = <int>[];
    for (int i = 0; i < length; i++) {
      final int randomValue = next(1, 16);
      if (!values.contains(randomValue)) {
        values.add(randomValue);
      } else {
        i--;
      }
    }
    return values;
  }

  void checkTappedBox(int value) {
    if(currentGameState == GameState.userInteraction){
      if (currentSequence[0] == value){
        currentSequence.removeAt(0);
        if (currentSequence.isEmpty){
          showGameFinished();
        }
      } else {
        currentGameState = GameState.gameOver;
        showGameOverDialog();
      }
    }
  }

  void showGameOverDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: const Text('Game over'),
            content: const Text(
                'You did not tap the right box. Game over.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Timer(const Duration(seconds: 1), () {
                    startSequence();
                  });
                  Navigator.pop(context);
                },
              )
            ]));
  }

  void showGameFinished(){
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: const Text('You have successfully finished the level.'),
            content: const Text(
                'Tap Ok to enter the next level.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Timer(const Duration(seconds: 1), () {
                    startSequence();
                  });
                  Navigator.pop(context);
                },
              )
            ]));
  }

  void startSequence() {
    const int length = 3;
    currentSequence = getSequence(length);
    currentPrimary.value = currentSequence[i];
    Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (i == length - 1) {
        i = 0;
        currentPrimary.value = 0;
        timer.cancel();
        startUserInteraction();
      } else {
        i++;
        currentPrimary.value = currentSequence[i];
      }
    });
  }

  void startUserInteraction() {
    showUserDialog();
    currentGameState = GameState.userInteraction;
  }

  void showStartDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: const Text('Start Game'),
                content: const Text(
                    'When you tap on "OK" the game will start. Then you have to remeber all the boxes that flash up.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Timer(const Duration(seconds: 1), () {
                        startSequence();
                      });
                      Navigator.pop(context);
                    },
                  )
                ]));
  }

  void showUserDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: const Text('Now its your turn'),
                content:
                    const Text('Tap the boxes in the order shown earlier.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ]));
  }
}

enum GameState {
  start,
  showSequence,
  userInteraction,
  gameOver,
}
