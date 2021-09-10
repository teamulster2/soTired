import 'dart:async';
import 'package:flutter/material.dart';
import 'package:so_tired/ui/models/exceptions.dart';
import 'package:so_tired/ui/modules/spatial_span_test/engine/game_engine.dart';

abstract class GameState {
  late GameEngine engine;

  void setGameEngine(GameEngine engine) {
    this.engine = engine;
  }

  void handleState();

  void checkUserInteraction(int boxId);
}

class StartState extends GameState {
  StartState() : super();

  @override
  void handleState() {
    engine.showDialog(InfoDialogObject('Start Game',
        'When you tap on "OK" the game will start. Then you have to remember all the boxes that flash up.',
        () {
      Timer(Duration(milliseconds: engine.durationTilesShown), () {
        engine
          ..transitionTo(ShowSequenceState())
          ..handleState();
      });
    }, () {}, true, false, false));
  }

  @override
  void checkUserInteraction(int boxId) {
    throw GameWrongStateException();
  }
}

class ShowSequenceState extends GameState {
  ShowSequenceState() : super();

  @override
  void handleState() {
    engine.startSequence(() {
      engine
        ..transitionTo(UserInteractionState())
        ..handleState();
    });
  }

  @override
  void checkUserInteraction(int boxId) {
    throw GameWrongStateException();
  }
}

class UserInteractionState extends GameState {
  UserInteractionState() : super();

  @override
  void handleState() {
    engine.showDialog(InfoDialogObject(
        'Now its your turn', 'Tap the boxes in the order shown earlier.', () {
      //TODO: add on tap
    }, () {}, true, false, false));
  }

  @override
  void checkUserInteraction(int boxId) {
    final int value = engine.checkTappedBox(boxId);
    if (value == 1) {
      engine
        ..transitionTo(NextLevelState())
        ..handleState();
    } else if (value == 2) {
      engine
        ..transitionTo(GameOverState())
        ..handleState();
    }
  }
}

class GameOverState extends GameState {
  GameOverState() : super();

  @override
  void checkUserInteraction(int boxId) {
    throw GameWrongStateException();
  }

  @override
  void handleState() {
    engine.showDialog(InfoDialogObject(
        'Game over',
        'You did not tap the right box. Game over.',
        () {},
        () {},
        false,
        true,
        true));
  }
}

class NextLevelState extends GameState {
  @override
  void checkUserInteraction(int boxId) {
    throw GameWrongStateException();
  }

  @override
  void handleState() {
    engine.showDialog(InfoDialogObject(
        'You have successfully finished level ${engine.level.value}.',
        'Tap Ok to enter the next level.', () {
      engine.level.value++;
      Timer(Duration(milliseconds: engine.durationTilesShown), () {
        engine
          ..transitionTo(ShowSequenceState())
          ..handleState();
      });
    }, () {}, true, false, false));
  }
}

class InfoDialogObject {
  String title;
  String content;
  VoidCallback onOk;
  VoidCallback onCancel;
  bool onOkPop;
  bool onOkPush;
  bool dialogColored;

  InfoDialogObject(this.title, this.content, this.onOk, this.onCancel,
      this.onOkPop, this.onOkPush, this.dialogColored);
}
