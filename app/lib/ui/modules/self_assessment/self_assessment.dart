import 'package:flutter/material.dart';
import 'package:so_tired/ui/core/navigation/navigation.dart';
import 'package:so_tired/ui/core/navigation/navigation_drawer.dart';
import 'package:so_tired/ui/modules/self_assessment/widgets/current_activity.dart';
import 'package:so_tired/ui/modules/self_assessment/widgets/current_emotional_state.dart';
import 'package:so_tired/ui/modules/spatial_span_test/spatial_span_test.dart';

class SelfAssessment extends StatefulWidget {
  const SelfAssessment({Key? key}) : super(key: key);

  @override
  _SelfAssessmentState createState() => _SelfAssessmentState();
}

class _SelfAssessmentState extends State<SelfAssessment> {
  late ValueNotifier<int> emotionalState = ValueNotifier<int>(0);
  late int currentActivity;

  @override
  Widget build(BuildContext context) {
    emotionalState.value = 0;
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: NavigationBar(),
        ),
        drawer: const NavigationDrawer(),
        body: Container(
          color: Theme.of(context).backgroundColor,
          height: MediaQuery.of(context).size.height,
          child: ValueListenableBuilder<int>(
              valueListenable: emotionalState,
              builder: (BuildContext context, int value, Widget? child) =>
                  getWidget()),
        ));
  }

  Widget getWidget() {
    if (emotionalState.value == 0) {
      return CurrentEmotionalState(onTap: (int value) {
        emotionalState.value = value;
      });
    } else {
      return CurrentActivity(onTap: (int value) {
        currentActivity = value;
        Navigator.push(
            context,
            MaterialPageRoute<BuildContext>(
                builder: (BuildContext context) =>
                const SpatialSpanTest()));
      });
    }
  }
}
