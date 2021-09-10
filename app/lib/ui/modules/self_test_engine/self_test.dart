import 'package:flutter/material.dart';
import 'package:so_tired/ui/core/home/home.dart';
import 'package:so_tired/ui/core/navigation/navigation.dart';
import 'package:so_tired/ui/core/navigation/navigation_drawer.dart';
import 'package:so_tired/ui/modules/self_assessment/self_assessment.dart';
import 'package:so_tired/ui/modules/self_test_engine/self_test_engine.dart';
import 'package:so_tired/ui/modules/self_test_engine/self_test_state.dart';
import 'package:so_tired/ui/modules/spatial_span_test/engine/game_state.dart';
import 'package:so_tired/ui/modules/spatial_span_test/spatial_span_test.dart';

class SelfTest extends StatefulWidget {
  const SelfTest({Key? key}) : super(key: key);

  @override
  _SelfTestState createState() => _SelfTestState();
}

class _SelfTestState extends State<SelfTest> {
  late SelfTestEngine engine;

  @override
  Widget build(BuildContext context) {
    engine = SelfTestEngine(StartSelfTestState(), (InfoDialogObject ido) {
      showInfoDialog(ido);
    });

    Future<dynamic>.delayed(Duration.zero, () => engine.handleState());
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: NavigationBar(),
      ),
      drawer: const NavigationDrawer(),
      body: ValueListenableBuilder<SelfTestState>(
          valueListenable: engine.currentState,
          builder: (BuildContext builder, Object? value, Widget? widget) =>
              Container(
                  color: Theme.of(context).backgroundColor,
                  child: setContent())),
    );
  }

  Widget setContent() {
    if (engine.currentState.value.toString() ==
        SelfAssessmentState().toString()) {
      return SelfAssessment(
        onFinished: () => engine.handleState(),
      );
    } else if (engine.currentState.value.toString() ==
        SpatialSpanTaskState().toString()) {
      return SpatialSpanTest(
        onFinished: () => engine.handleState(),
      );
    } else if (engine.currentState.value.toString() == PVTState().toString()) {
      return Container();
    }
    return Container();
  }

  void showInfoDialog(InfoDialogObject ido) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: Text(ido.title),
                content: Text(ido.content),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      ido.onCancel();
                      Navigator.push(
                          context,
                          MaterialPageRoute<BuildContext>(
                              builder: (BuildContext context) => const Home()));
                    },
                  ),
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
                  ),
                ]));
  }
}
