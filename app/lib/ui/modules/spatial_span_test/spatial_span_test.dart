import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_tired/database/models/user/user_game_type.dart';
import 'package:so_tired/database/models/score/personal_high_score.dart';
import 'package:so_tired/database/models/user/user_access_method.dart';
import 'package:so_tired/database/models/user/user_log.dart';
import 'package:so_tired/service_provider/service_provider.dart';
import 'package:so_tired/ui/core/home/home.dart';
import 'package:so_tired/ui/models/dialog_objects.dart';
import 'package:so_tired/ui/modules/spatial_span_test/engine/game_engine.dart';
import 'package:so_tired/ui/modules/spatial_span_test/engine/game_state.dart';
import 'package:so_tired/ui/modules/spatial_span_test/widgets/spatial_span_test_box.dart';
import 'package:so_tired/ui/modules/spatial_span_test/widgets/spatial_span_test_progress.dart';
import 'package:so_tired/utils/utils.dart';

/// This class contains the spatial span test widget.
/// [GameEngine] with business logic to set variables
class SpatialSpanTest extends StatefulWidget {
  const SpatialSpanTest(
      {required this.onFinished, required this.setLevel, Key? key})
      : super(key: key);

  final VoidCallback onFinished;
  final Function(int) setLevel;

  @override
  _SpatialSpanTestState createState() => _SpatialSpanTestState();
}

class _SpatialSpanTestState extends State<SpatialSpanTest> {
  late GameEngine gameEngine;

  @override
  Widget build(BuildContext context) {
    gameEngine = GameEngine(StartState(), (InfoDialogObject ido) {
      if (ido.dialogColored) {
        showGameOverDialog(ido);
      } else {
        showInfoDialog(ido);
      }
    });

    Future<dynamic>.delayed(Duration.zero, () => gameEngine.handleState());

    return Container(
        color: Theme.of(context).backgroundColor,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
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
                                    valueListenable: gameEngine.currentPrimary,
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
          ),
        ));
  }

  /// This method shows the info dialog corresponding to the [InfoDialogObject].
  void showInfoDialog(InfoDialogObject ido) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                  title: Text(ido.title),
                  content: Text(ido.content),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Ok'),
                      onPressed: () {
                        ido.onOk();
                        if (ido.onOkPop) {
                          Navigator.pop(context);
                        } else if (ido.onOkPush) {
                          Navigator.push(
                              context,
                              MaterialPageRoute<BuildContext>(
                                  builder: (BuildContext context) =>
                                      const Home()));
                        }
                      },
                    )
                  ]),
            ));
  }

  /// This method shows the game over dialog corresponding to the [InfoDialogObject] with the information given.
  /// This dialog has a pink background to highlight the game over.
  void showGameOverDialog(InfoDialogObject ido) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                  backgroundColor: Theme.of(context).primaryColorLight,
                  title: Text(ido.title),
                  content: Text(ido.content),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Ok'),
                      onPressed: () {
                        ido.onOk();
                        if (ido.onOkPop) {
                          Navigator.pop(context);
                        } else if (ido.onOkPush) {
                          widget.setLevel(gameEngine.level.value - 1);

                          final Map<UserGameType, Map<String, dynamic>>
                              gameValue = <UserGameType, Map<String, dynamic>>{
                            UserGameType.spatialSpanTask: <String, dynamic>{
                              'levels': gameEngine.level.value - 1
                            }
                          };
                          Provider.of<ServiceProvider>(context, listen: false)
                              .databaseManager
                              .writeUserLogs(<UserLog>[
                            UserLog(
                                Utils.generateUuid(),
                                UserAccessMethod.regularAppStart,
                                gameValue,
                                DateTime.now().toString())
                          ]);

                          Provider.of<ServiceProvider>(context, listen: false)
                              .databaseManager
                              .writePersonalHighScores(<PersonalHighScore>[
                            PersonalHighScore(
                                Utils.generateUuid(),
                                gameEngine.level.value - 1,
                                UserGameType.spatialSpanTask)
                          ]);

                          widget.onFinished();
                        }
                      },
                    )
                  ]),
            ));
  }
}
