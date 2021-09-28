import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_tired/database/models/user/user_state.dart';
import 'package:so_tired/service_provider/service_provider.dart';
import 'package:so_tired/ui/modules/self_assessment/widgets/current_activity.dart';
import 'package:so_tired/ui/modules/self_assessment/widgets/current_emotional_state.dart';
import 'package:so_tired/utils/utils.dart';

/// This widget shows the whole self assessment part of the app.
/// Sets the mood (current emotional state) and the activity of the subject.
class SelfAssessment extends StatefulWidget {
  const SelfAssessment(
      {required this.onFinished,
      required this.setMood,
      required this.setActivity,
      required this.selfTestUuid,
      Key? key})
      : super(key: key);

  final VoidCallback onFinished;
  final Function(String) setMood;
  final Function(String) setActivity;

  final String selfTestUuid;

  @override
  _SelfAssessmentState createState() => _SelfAssessmentState();
}

class _SelfAssessmentState extends State<SelfAssessment> {
  late ValueNotifier<List<int>> emotionalState =
      ValueNotifier<List<int>>(<int>[]);
  late List<int> currentActivity;

  @override
  Widget build(BuildContext context) {
    emotionalState.value = <int>[];
    return Container(
      color: Theme.of(context).backgroundColor,
      height: MediaQuery.of(context).size.height,
      child: ValueListenableBuilder<List<int>>(
          valueListenable: emotionalState,
          builder: (BuildContext context, List<int> value, Widget? child) =>
              getWidget()),
    );
  }

  /// This method returns the widget with the mood or activity question.
  Widget getWidget() {
    if (emotionalState.value.isEmpty) {
      return CurrentEmotionalState(onTap: (List<int> value) {
        emotionalState.value = value;
      });
    } else {
      return CurrentActivity(onTap: (List<int> value) {
        currentActivity = value;
        final String uuid = Utils.generateUuid();
        Provider.of<ServiceProvider>(context, listen: false)
            .databaseManager
            .writeUserStates(<UserState>[
          UserState(uuid, currentActivity, emotionalState.value, DateTime.now(),
              widget.selfTestUuid)
        ]);
        widget.setMood(Utils.codeUnitsToString(emotionalState.value));
        widget.setActivity(Utils.codeUnitsToString(currentActivity));
        widget.onFinished();
      });
    }
  }
}
