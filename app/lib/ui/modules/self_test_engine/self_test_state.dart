import 'package:so_tired/ui/modules/self_test_engine/self_test_engine.dart';
import 'package:so_tired/ui/modules/spatial_span_test/engine/game_state.dart';

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
    engine.showDialog(InfoDialogObject('We will ask you two questions now.',
        'When you want to leave the self test press Cancel', () {
      engine.transitionTo(SelfAssessmentState());
    }, () {}, true, false, false));
  }
}

class SelfAssessmentState extends SelfTestState {
  @override
  void handleState() {
    engine.showDialog(InfoDialogObject(
        'Thank you for answering the questions. Now you will be forwarded to a pvt test',
        'When you want to leave the self test press Cancel', () {
      engine.transitionTo(PVTState());
    }, () {}, true, false, false));
  }
}

class SpatialSpanTaskState extends SelfTestState {
  @override
  void handleState() {
    engine.showDialog(InfoDialogObject(
        'Thank you for doing the spatial span task state. You will now return to the home page.',
        'When you want to leave the self test press Cancel',
        () {},
        () {},
        false,
        true,
        false));
  }
}

class PVTState extends SelfTestState {
  @override
  void handleState() {
    engine.showDialog(InfoDialogObject(
        'Thank you for answering the questions. Now you will be forwarded to a spatial span test',
        'When you want to leave the self test press Cancel', () {
      engine.transitionTo(SpatialSpanTaskState());
    }, () {}, true, false, false));
  }
}
