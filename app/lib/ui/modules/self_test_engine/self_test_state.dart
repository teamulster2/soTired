import 'package:so_tired/ui/models/dialog_objects.dart';
import 'package:so_tired/ui/modules/self_test_engine/self_test_engine.dart';

abstract class SelfTestState {
  late SelfTestEngine engine;

  void setSelfTestEngine(SelfTestEngine engine) {
    this.engine = engine;
  }

  void handleState();
}

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
        progress: 'Step 1 of 3'));
  }
}

class SelfAssessmentState extends SelfTestState {
  @override
  void handleState() {
    engine.showDialog(ProgressDialogObject(
        title:
            'Thank you for answering the questions. Now you will be forwarded to a pvt test',
        content: 'When you want to leave the self test press Cancel',
        progress: 'Step 2 of 3',
        onOk: () {
          engine.transitionTo(PVTState());
        },
        onOkPush: false,
        onCancel: () {}));
  }
}

class SpatialSpanTaskState extends SelfTestState {
  @override
  void handleState() {
    engine.showDialog(ProgressDialogObject(
        title:
            'Thank you for doing the spatial span task state. You will now return to the home page.',
        content: 'When you want to leave the self test press Cancel',
        progress: 'Finished.',
        onOk: () {},
        onOkPush: true,
        onCancel: () {}));
  }
}

class PVTState extends SelfTestState {
  @override
  void handleState() {
    engine.showDialog(ProgressDialogObject(
        title:
            'Thank you doing the pvt test. Now you will be forwarded to a spatial span test',
        content: 'When you want to leave the self test press Cancel',
        progress: 'Step 3 of 3',
        onOk: () {
          engine.transitionTo(SpatialSpanTaskState());
        },
        onOkPush: false,
        onCancel: () {}));
  }
}
