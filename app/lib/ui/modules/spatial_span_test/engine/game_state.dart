import 'dart:async';
import 'package:flutter/material.dart';
import 'package:so_tired/ui/modules/spatial_span_test/engine/game_engine.dart';

abstract class GameState {
  late GameEngine engine;

  void setGameEngine(GameEngine engine) {
    this.engine = engine;
  }

  void startGame();

  void showSequence();

  void startUserInteraction();

  void checkUserInteraction(int boxId);

  void gameOver();

  void toNextLevel();
}

class StartState extends GameState {
  StartState() : super();

  @override
  void startGame() {
    engine.showDialog(InfoDialogObject('Start Game',
        'When you tap on "OK" the game will start. Then you have to remember all the boxes that flash up.',
        () {
      Timer(Duration(milliseconds: engine.durationTilesShown), () {
        engine
          ..transitionTo(ShowSequenceState())
          ..showSequence();
      });
    }, true, false, false));
  }

  @override
  void showSequence() {
    // TODO: implement showSequence
  }

  @override
  void startUserInteraction() {
    // TODO: implement startUserInteraction
  }

  @override
  void checkUserInteraction(int boxId) {
    // TODO: implement checkTappedBox
  }

  @override
  void gameOver() {
    // TODO: implement gameOver
  }

  @override
  void toNextLevel() {
    // TODO: implement toNextLevel
  }
}

class ShowSequenceState extends GameState {
  ShowSequenceState() : super();

  @override
  void startGame() {
    // TODO: implement toStartState
  }

  @override
  void showSequence() {
    engine.startSequence(() {
      engine
        ..transitionTo(UserInteractionState())
        ..startUserInteraction();
    });
  }

  @override
  void startUserInteraction() {
    // TODO: implement startUserInteraction
  }

  @override
  void checkUserInteraction(int boxId) {
    // TODO: implement checkTappedBox
  }

  @override
  void gameOver() {
    // TODO: implement gameOver
  }

  @override
  void toNextLevel() {
    // TODO: implement toNextLevel
  }
}

class UserInteractionState extends GameState {
  UserInteractionState() : super();

  @override
  void startGame() {
    // TODO: implement toStartState
  }

  @override
  void showSequence() {
    // TODO: implement showSequence
  }

  @override
  void startUserInteraction() {
    engine.showDialog(InfoDialogObject(
        'Now its your turn', 'Tap the boxes in the order shown earlier.', () {
      //TODO: add on tap
    }, true, false, false));
  }

  @override
  void checkUserInteraction(int boxId) {
    final int value = engine.checkTappedBox(boxId);
    if (value == 1) {
      engine
        ..transitionTo(NextLevelState())
        ..toNextLevel();
    } else if (value == 2) {
      engine
        ..transitionTo(GameOverState())
        ..gameOver();
    }
  }

  @override
  void gameOver() {
    // TODO: implement gameOver
  }

  @override
  void toNextLevel() {
    // TODO: implement toNextLevel
  }
}

class GameOverState extends GameState {
  GameOverState() : super();

  @override
  void startGame() {
    // TODO: implement toStartState
  }

  @override
  void showSequence() {
    // TODO: implement showSequence
  }

  @override
  void startUserInteraction() {
    // TODO: implement startUserInteraction
  }

  @override
  void checkUserInteraction(int boxId) {
    // TODO: implement checkTappedBox
  }

  @override
  void gameOver() {
    engine.showDialog(InfoDialogObject('Game over',
        'You did not tap the right box. Game over.', () {}, false, true, true));
  }

  @override
  void toNextLevel() {
    // TODO: implement toNextLevel
  }
}

class NextLevelState extends GameState {
  @override
  void checkUserInteraction(int boxId) {
    // TODO: implement checkTappedBox
  }

  @override
  void gameOver() {
    // TODO: implement gameOver
  }

  @override
  void showSequence() {
    // TODO: implement showSequence
  }

  @override
  void startGame() {
    // TODO: implement startGame
  }

  @override
  void startUserInteraction() {
    // TODO: implement startUserInteraction
  }

  @override
  void toNextLevel() {
    engine.showDialog(InfoDialogObject(
        'You have successfully finished level ${engine.level.value}.',
        'Tap Ok to enter the next level.', () {
      engine.level.value++;
      Timer(Duration(milliseconds: engine.durationTilesShown), () {
        engine
          ..transitionTo(ShowSequenceState())
          ..showSequence();
      });
    }, true, false, false));
  }
}

class InfoDialogObject {
  String title;
  String content;
  VoidCallback onOk;
  bool pop;
  bool push;
  bool colored;

  InfoDialogObject(
      this.title, this.content, this.onOk, this.pop, this.push, this.colored);
}
