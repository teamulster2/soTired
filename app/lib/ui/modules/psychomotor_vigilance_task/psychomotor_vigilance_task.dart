import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_tired/database/models/user/user_game_type.dart';
import 'package:so_tired/database/models/score/personal_high_score.dart';
import 'package:so_tired/database/models/user/user_access_method.dart';
import 'package:so_tired/database/models/user/user_log.dart';
import 'package:so_tired/service_provider/service_provider.dart';
import 'package:so_tired/ui/modules/psychomotor_vigilance_task/widgets/psychomotor_vigilance_task_diff.dart';
import 'package:so_tired/ui/modules/psychomotor_vigilance_task/widgets/psychomotor_vigilance_task_progress.dart';
import 'package:so_tired/ui/modules/psychomotor_vigilance_task/widgets/psychomotor_vigilance_task_square.dart';
import 'package:so_tired/utils/utils.dart';

class PsychomotorVigilanceTask extends StatefulWidget {
  const PsychomotorVigilanceTask(
      {required this.onFinished,
      required this.setDiff,
      required this.selfTestUuid,
      Key? key})
      : super(key: key);

  final VoidCallback onFinished;
  final Function(int) setDiff;

  final String selfTestUuid;

  @override
  _PsychomotorVigilanceTaskState createState() =>
      _PsychomotorVigilanceTaskState();
}

/// This widget holds the whole pvt test.
/// The game engine is included.
/// Widgets used: [PsychomotorVigilanceTaskProgress], [PsychomotorVigilanceTaskSquare] and [PsychomotorVigilanceTaskDiff].
class _PsychomotorVigilanceTaskState extends State<PsychomotorVigilanceTask>
    with WidgetsBindingObserver {
  ValueNotifier<bool> boxAppears = ValueNotifier<bool>(false);

  final int max = 3;
  final ValueNotifier<int> counter = ValueNotifier<int>(3);

  int next(int min, int max) => min + Random().nextInt(max - min);
  bool boxInPlanning = false;
  bool setDiff = true;

  int diff = 0;
  final ValueNotifier<bool> showDiff = ValueNotifier<bool>(false);

  int now = 0;
  List<int> diffs = <int>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      now = DateTime.now().millisecondsSinceEpoch;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<dynamic>.delayed(Duration.zero, () {
      showInfoDialog();
    });
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ValueListenableBuilder<bool>(
            valueListenable: boxAppears,
            builder: (BuildContext context, Object? value, Widget? widget) =>
                InkWell(
                  onTap: () {
                    calculateAndShowDiff();
                  },
                  child: Column(
                    children: <Widget>[
                      ValueListenableBuilder<int>(
                          valueListenable: counter,
                          builder: (BuildContext context, Object? value,
                                  Widget? widget) =>
                              PsychomotorVigilanceTaskProgress(
                                  counter: counter.value, max: max)),
                      Container(
                          height: MediaQuery.of(context).size.height - 300,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Visibility(
                                  visible: boxAppears.value,
                                  child:
                                      const PsychomotorVigilanceTaskSquare()),
                              ValueListenableBuilder<bool>(
                                valueListenable: showDiff,
                                builder: (BuildContext context, Object? value,
                                        Widget? widget) =>
                                    Visibility(
                                        visible: showDiff.value,
                                        child: PsychomotorVigilanceTaskDiff(
                                            diff: diff.toString())),
                              ),
                            ],
                          )),
                    ],
                  ),
                )));
  }

  void startPVT() {
    Timer.periodic(const Duration(milliseconds: 1000), (Timer timer) {
      if (!boxAppears.value && !boxInPlanning) {
        boxInPlanning = true;
        Future<dynamic>.delayed(Duration(seconds: next(1, 3)), () {
          boxAppears.value = true;
          now = DateTime.now().millisecondsSinceEpoch;
          setDiff = true;
        });
      }
      if (counter.value < 1) {
        boxAppears.value = false;
        timer.cancel();
        widget.setDiff(calculateAverageDiff().round());

        final Map<UserGameType, Map<String, dynamic>> gameValue =
            <UserGameType, Map<String, dynamic>>{
          UserGameType.psychomotorVigilanceTask: <String, dynamic>{
            'diffs': diffs
          }
        };
        Provider.of<ServiceProvider>(context, listen: false)
            .databaseManager
            .writeUserLogs(<UserLog>[
          UserLog(Utils.generateUuid(), UserAccessMethod.regularAppStart,
              gameValue, DateTime.now(), widget.selfTestUuid)
        ]);

        Provider.of<ServiceProvider>(context, listen: false)
            .databaseManager
            .writePersonalHighScores(<PersonalHighScore>[
          PersonalHighScore(Utils.generateUuid(),
              calculateAverageDiff().round(), UserGameType.spatialSpanTask)
        ]);
        widget.onFinished();
      }
    });
  }

  void showInfoDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                  title: const Text(
                      'We will now show you a turquoise square over and over '
                      'again. Each time it appears, please touch the '
                      'screen.'),
                  content: const Text('To start the game press Ok.'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Ok'),
                      onPressed: () {
                        startPVT();
                        Navigator.pop(context);
                      },
                    )
                  ]),
            ));
  }

  calculateAndShowDiff() {
    diff = DateTime.now().millisecondsSinceEpoch - now;
    if (boxAppears.value && boxInPlanning && setDiff) {
      diffs.add(diff);
      showDiff.value = true;
      setDiff = false;

      Future<dynamic>.delayed(const Duration(seconds: 1), () {
        showDiff.value = false;
      });

      boxAppears.value = false;
      boxInPlanning = false;
      counter.value -= 1;
    }
  }

  double calculateAverageDiff() {
    int all = 0;
    for (int i = 0; i < diffs.length; i++) {
      all += diffs[i];
    }
    return all / diffs.length;
  }
}
