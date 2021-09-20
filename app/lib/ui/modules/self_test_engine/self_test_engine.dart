import 'package:flutter/material.dart';
import 'package:so_tired/ui/models/dialog_objects.dart';
import 'package:so_tired/ui/modules/self_test_engine/self_test_state.dart';

/// This class contains the self test engine, that holds the current state of the self test and has the handleState methods as far as the transition functionality.
class SelfTestEngine {
  late SelfTestState selfTestState;
  Function(ProgressDialogObject) showDialog;

  late ValueNotifier<SelfTestState> currentState =
      ValueNotifier<SelfTestState>(StartSelfTestState());

  late String currentMood;
  late String currentActivity;
  late int averageDiffPVT;
  late int levelSpatialSpanTask;

  late BuildContext context;

  SelfTestEngine(SelfTestState selfTestState, this.showDialog, this.context) {
    transitionTo(selfTestState);
    currentState = ValueNotifier<SelfTestState>(selfTestState);
  }

  /// This method contains the transition functionality to change the state of the self test.
  void transitionTo(SelfTestState selfTestState) {
    this.selfTestState = selfTestState;
    this.selfTestState.setSelfTestEngine(this);
    currentState.value = selfTestState;
  }

  /// This method sets the handleState functionality of the current self test state.
  void handleState() {
    selfTestState.handleState();
  }
}
