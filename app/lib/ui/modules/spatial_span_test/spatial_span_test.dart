import 'dart:async';
import 'package:flutter/material.dart';
import 'package:so_tired/ui/core/home/home.dart';
import 'package:so_tired/ui/core/navigation/navigation.dart';
import 'package:so_tired/ui/core/navigation/navigation_drawer.dart';
import 'package:so_tired/ui/modules/spatial_span_test/engine/game_engine.dart';
import 'package:so_tired/ui/modules/spatial_span_test/engine/game_state.dart';
import 'package:so_tired/ui/modules/spatial_span_test/widgets/spatial_span_test_box.dart';
import 'package:so_tired/ui/modules/spatial_span_test/widgets/spatial_span_test_progress.dart';

class SpatialSpanTest extends StatefulWidget {
  const SpatialSpanTest({Key? key}) : super(key: key);

  @override
  _SpatialSpanTestState createState() => _SpatialSpanTestState();
}

class _SpatialSpanTestState extends State<SpatialSpanTest> {
  late GameEngine gameEngine;

  @override
  Widget build(BuildContext context) {
    gameEngine = GameEngine(StartState(), (InfoDialogObject ido) {
      if (ido.colored) {
        showGameOverDialog(ido);
      } else {
        showInfoDialog(ido);
      }
    });

    Future<dynamic>.delayed(Duration.zero, () => gameEngine.startGame());

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
                SpatialSpanTestProgress(
                    level: gameEngine.level,
                    currentValue: gameEngine.currentValue),
                SizedBox(
                    height: MediaQuery.of(context).size.height - 250,
                    width: MediaQuery.of(context).size.width,
                    child: GridView.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: <Widget>[
                        for (int i = 1; i < 17; i++)
                          ValueListenableBuilder<List<int>>(
                              valueListenable: gameEngine.currentSequence,
                              builder: (BuildContext context, Object? value,
                                      Widget? widget) =>
                                  ValueListenableBuilder<int>(
                                      valueListenable:
                                          gameEngine.currentPrimary,
                                      builder: (BuildContext context,
                                              Object? value, Widget? widget) =>
                                          SpatialSpanTestBox(
                                            primary: i ==
                                                gameEngine.currentPrimary.value,
                                            onTap: () => gameEngine
                                                .checkUserInteraction(i),
                                          ))),
                      ],
                    )),
              ],
            )));
  }

  void showInfoDialog(InfoDialogObject ido) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: Text(ido.title),
                content: Text(ido.content),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      ido.onOk();
                      if (ido.pop) {
                        Navigator.pop(context);
                      } else if (ido.push) {
                        Navigator.push(
                            context,
                            MaterialPageRoute<BuildContext>(
                                builder: (BuildContext context) =>
                                    const Home()));
                      }
                    },
                  )
                ]));
  }

  void showGameOverDialog(InfoDialogObject ido) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                backgroundColor: Theme.of(context).primaryColorLight,
                title: Text(ido.title),
                content: Text(ido.content),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      ido.onOk();
                      if (ido.pop) {
                        Navigator.pop(context);
                      } else if (ido.push) {
                        Navigator.push(
                            context,
                            MaterialPageRoute<BuildContext>(
                                builder: (BuildContext context) =>
                                    const Home()));
                      }
                    },
                  )
                ]));
  }
}
