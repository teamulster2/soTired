import 'dart:async';
import 'dart:math';
import 'package:so_tired/ui/models/exceptions.dart';
import 'package:so_tired/ui/modules/spatial_span_test/engine/game_state.dart';
import 'package:flutter/material.dart';

class GameEngine {
  late GameState gameState;
  Function(InfoDialogObject) showDialog;

  final int durationTilesShown = 500;

  int next(int min, int max) => min + Random().nextInt(max - min);
  final ValueNotifier<List<int>> currentSequence =
      ValueNotifier<List<int>>(<int>[]);
  final ValueNotifier<int> level = ValueNotifier<int>(1);
  final ValueNotifier<int> currentValue = ValueNotifier<int>(0);
  int i = 0;

  final ValueNotifier<int> currentPrimary = ValueNotifier<int>(0);

  GameEngine(GameState gameState, this.showDialog) {
    transitionTo(gameState);
  }

  void transitionTo(GameState gameState) {
    this.gameState = gameState;
    this.gameState.setGameEngine(this);
  }

  void handleState() {
    gameState.handleState();
  }

  void checkUserInteraction(int boxId) {
    try {
      gameState.checkUserInteraction(boxId);
    } on GameWrongStateException {
      showDialog(InfoDialogObject(
          'Exception', 'Something went wrong. Please restart the application',
          () {
        // TODO: onTap ok
      }, false, true, true));
    }
  }

  void startSequence(VoidCallback transition) {
    currentValue.value = 0;
    currentSequence.value = getSequence(level.value);
    currentPrimary.value = currentSequence.value[i];
    Timer.periodic(Duration(milliseconds: durationTilesShown), (Timer timer) {
      if (i == level.value - 1) {
        i = 0;
        currentPrimary.value = 0;
        timer.cancel();
        transition();
      } else {
        i++;
        currentPrimary.value = currentSequence.value[i];
      }
    });
  }

  List<int> getSequence(int length) {
    final List<int> values = <int>[];
    for (int i = 0; i < length; i++) {
      final int randomValue = next(1, 16);
      if (!values.contains(randomValue)) {
        values.add(randomValue);
      } else {
        i--;
      }
    }
    return values;
  }

  int checkTappedBox(int boxId) {
    if (currentSequence.value[0] == boxId) {
      currentSequence.value.removeAt(0);
      currentValue.value += 1;
      if (currentSequence.value.isEmpty) {
        return 1;
      }
    } else {
      return 2;
    }
    return 0;
  }
}
