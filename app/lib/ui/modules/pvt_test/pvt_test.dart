import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:so_tired/ui/modules/pvt_test/widgets/pvt_test_diff.dart';
import 'package:so_tired/ui/modules/pvt_test/widgets/pvt_test_progress.dart';
import 'package:so_tired/ui/modules/pvt_test/widgets/pvt_test_square.dart';

class PVTTest extends StatefulWidget {
  const PVTTest({required this.onFinished, Key? key}) : super(key: key);

  final VoidCallback onFinished;

  @override
  _PVTTestState createState() => _PVTTestState();
}

class _PVTTestState extends State<PVTTest> {
  ValueNotifier<bool> boxAppears = ValueNotifier<bool>(false);

  final int max = 3;
  final ValueNotifier<int> counter = ValueNotifier<int>(3);

  int next(int min, int max) => min + Random().nextInt(max - min);
  bool boxInPlanning = false;

  final ValueNotifier<int> diff = ValueNotifier<int>(0);
  final ValueNotifier<bool> showDiff = ValueNotifier<bool>(false);

  int now = 0;

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
                              PVTTestProgress(
                                  counter: counter.value, max: max)),
                      Container(
                          height: MediaQuery.of(context).size.height - 300,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Visibility(
                                  visible: boxAppears.value,
                                  child: const PVTTestSquare()),
                              ValueListenableBuilder<bool>(
                                valueListenable: showDiff,
                                builder: (BuildContext context, Object? value,
                                        Widget? widget) =>
                                    Visibility(
                                  visible: showDiff.value,
                                  child: ValueListenableBuilder<int>(
                                      valueListenable: diff,
                                      builder: (BuildContext context,
                                              Object? value, Widget? widget) =>
                                          PVTTestDiff(
                                              diff: diff.value.toString())),
                                ),
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
        });
      }
      if (counter.value < 1) {
        boxAppears.value = false;
        timer.cancel();
        widget.onFinished();
      }
    });
  }

  void showInfoDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: const Text(
                    'We will now show you a turquoise square over and over again. Each time it appears, please touch the screen.'),
                content: const Text('To start the game press Ok.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      startPVT();
                      Navigator.pop(context);
                    },
                  )
                ]));
  }

  calculateAndShowDiff() {
    diff.value = DateTime.now().millisecondsSinceEpoch - now;
    if (boxAppears.value && boxInPlanning) {
      showDiff.value = true;
      Future<dynamic>.delayed(const Duration(seconds: 1), () {
        showDiff.value = false;
      });
      boxAppears.value = false;
      boxInPlanning = false;
      counter.value -= 1;
    }
  }
}
