import 'package:flutter/material.dart';
import 'package:so_tired/ui/models/dialog_objects.dart';
import 'package:so_tired/ui/modules/self_test_engine/self_test_state.dart';

class SelfTestEngine {
  late SelfTestState selfTestState;
  Function(ProgressDialogObject) showDialog;

  late ValueNotifier<SelfTestState> currentState =
      ValueNotifier<SelfTestState>(StartSelfTestState());

  late String currentMood;
  late String currentActivity;
  late int averageDiffPVT;
  late int levelSpatialSpanTask;

  SelfTestEngine(SelfTestState selfTestState, this.showDialog) {
    transitionTo(selfTestState);
    currentState = ValueNotifier<SelfTestState>(selfTestState);
  }

  void transitionTo(SelfTestState selfTestState) {
    this.selfTestState = selfTestState;
    this.selfTestState.setSelfTestEngine(this);
    currentState.value = selfTestState;
  }

  void handleState() {
    selfTestState.handleState();
  }
}
