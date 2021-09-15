import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_tired/database/models/user/user_state.dart';
import 'package:so_tired/service_provider.dart';
import 'package:so_tired/ui/modules/self_assessment/widgets/current_activity.dart';
import 'package:so_tired/ui/modules/self_assessment/widgets/current_emotional_state.dart';
import 'package:so_tired/utils.dart';

class SelfAssessment extends StatefulWidget {
  const SelfAssessment({required this.onFinished, Key? key}) : super(key: key);

  final VoidCallback onFinished;

  @override
  _SelfAssessmentState createState() => _SelfAssessmentState();
}

class _SelfAssessmentState extends State<SelfAssessment> {
  late ValueNotifier<List<int>> emotionalState =
      ValueNotifier<List<int>>(<int>[]);
  late String currentActivity;

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

  Widget getWidget() {
    if (emotionalState.value.isEmpty) {
      return CurrentEmotionalState(onTap: (List<int> value) {
        emotionalState.value = value;
      });
    } else {
      return CurrentActivity(onTap: (String value) {
        currentActivity = value;
        final String uuid = Utils.generateUuid();
        Provider.of<ServiceProvider>(context, listen: false)
            .databaseManager
            .writeUserStates(<UserState>[
          UserState(uuid, currentActivity, emotionalState.value)
        ]);
        widget.onFinished();
      });
    }
  }
}
