import 'dart:async';
import 'package:so_tired/ui/models/dialog_objects.dart';
import 'package:so_tired/ui/models/exceptions.dart';
import 'package:so_tired/ui/modules/spatial_span_test/engine/game_engine.dart';

/// This abstract class is the super class of all available game states.
/// It holds the game engine to set specific variables and values.
abstract class GameState {
  late GameEngine engine;

  void setGameEngine(GameEngine engine) {
    this.engine = engine;
  }

  void handleState();

  void checkUserInteraction(int boxId);
}

/// This class contains the functionality of the start state of the spatial span task.
class StartState extends GameState {
  StartState() : super();

  /// This method shows the start dialog and starts the first sequence of boxes shown.
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

/// This class contains the functionality of the show sequence state of the spatial span task.
class ShowSequenceState extends GameState {
  ShowSequenceState() : super();

  /// This method starts the user interaction state section of the game.
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

/// This class contains the functionality of the user interaction state of the spatial span task.
class UserInteractionState extends GameState {
  UserInteractionState() : super();

  /// This methods shows the 'now it is your turn' dialog.
  @override
  void handleState() {
    engine.showDialog(InfoDialogObject(
        'Now its your turn', 'Tap the boxes in the order shown earlier.', () {
      //TODO: add on tap
    }, () {}, true, false, false));
  }

  /// This method checks if the tapped boxes are in the right order and the right place.
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

/// This class contains the functionality of the game over state of the spatial span task.
class GameOverState extends GameState {
  GameOverState() : super();

  @override
  void checkUserInteraction(int boxId) {
    throw GameWrongStateException();
  }

  /// This method shows the game over dialog and stops the game.
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

/// This class contains the functionality of the next level state of the spatial span task.
class NextLevelState extends GameState {
  @override
  void checkUserInteraction(int boxId) {
    throw GameWrongStateException();
  }

  /// This methods shows the next level dialog and starts a new sequence of boxes shown.
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
