import 'package:so_tired/ui/models/dialog_objects.dart';
import 'package:so_tired/ui/modules/self_test_engine/self_test_engine.dart';

/// This abstract class sets the current engine and provides the handleState method that contains different functionality in all sub-states.
abstract class SelfTestState {
  late SelfTestEngine engine;

  void setSelfTestEngine(SelfTestEngine engine) {
    this.engine = engine;
  }

  void handleState();
}

/// This class contains the self test state functionality directly after starting the self test.
class StartSelfTestState extends SelfTestState {
  @override
  void handleState() {
    engine.showDialog(ProgressDialogObject(
        title: 'We will ask you two questions now.',
        content: 'When you want to leave the self test press Cancel',
        onOk: () {
          engine.transitionTo(SelfAssessmentState());
        },
        onCancel: () {},
        onOkPush: false,
        progress: 'Step 1 of 3',
        showCancel: true));
  }
}

/// This class contains the self test state functionality when the user is doing the self assessment.
/// Afterwards it forwards to the pvt test.
class SelfAssessmentState extends SelfTestState {
  @override
  void handleState() {
    engine.showDialog(ProgressDialogObject(
        title:
            'Thank you for answering the questions. Now you will be forwarded to a psychomotor vigilance task.',
        content: 'When you want to leave the self test press Cancel',
        progress: 'Step 2 of 3',
        onOk: () {
          engine.transitionTo(PVTState());
        },
        onOkPush: false,
        onCancel: () {},
        showCancel: true));
  }
}

/// This class contains the self test state functionality when the user is doing the spatial span task.
/// Afterwards it shows all results and returns to the home page.
class SpatialSpanTaskState extends SelfTestState {
  @override
  void handleState() {
    engine.showDialog(ProgressDialogObject(
        title:
            'Thank you for doing the self test. You will now return to the home page.',
        content: 'Your results:\n\nActivity: ' +
            engine.currentActivity +
            '\nEmotional state: ' +
            engine.currentMood +
            '\n\nAverage pvt time: ' +
            engine.averageDiffPVT.toString() +
            '\nLevel reached in spatial span task: ' +
            engine.levelSpatialSpanTask.toString(),
        progress: 'Finished.',
        onOk: () {},
        onOkPush: true,
        onCancel: () {},
        showCancel: false));
  }
}

/// This class contains the self test state functionality when the user is doing the pvt test.
/// Afterwards it forwards to the spatial span task test.
class PVTState extends SelfTestState {
  @override
  void handleState() {
    engine.showDialog(ProgressDialogObject(
        title:
            'Thank you for doing the psychomotor vigilance task. Now you will be forwarded to a spatial span task.',
        content: 'When you want to leave the self test press Cancel',
        progress: 'Step 3 of 3',
        onOk: () {
          engine.transitionTo(SpatialSpanTaskState());
        },
        onOkPush: false,
        onCancel: () {},
        showCancel: true));
  }
}
