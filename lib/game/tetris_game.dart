import 'dart:async';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris_game_flutter/core/core.dart';
import 'package:tetris_game_flutter/game/game.dart';

class TetrisGame extends FlameGame with KeyboardEvents, TapCallbacks {
  final Size screenSize;

  Playland playland = Playland();
  StatusLand statusLand = StatusLand();
  GameProvider gameProvider = GameProvider();
  GameStates gameStates = GameStates.none;

  Timer? timer;

  // ignore: non_constant_identifier_names
  double WIDTH = 0;
// ignore: constant_identifier_names, non_constant_identifier_names
  double HEIGHT = 0;

  TetrisGame({
    required this.screenSize,
  });
  List<List<int>> mixed = [];
  List<Briks> briksPool = [];

  @override
  Color backgroundColor() => const Color(0xFF9EAD86);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size.setValues(screenSize.width, screenSize.height);
    WIDTH = 285;
    HEIGHT = 569;

    AudioManager.instance.initAudio();

    playland.y = playland.position.y = size.y * 0.12;
    playland.position.x = (size.x - WIDTH) / 2 - 5;

    statusLand.position.y = size.y * 0.02;
    statusLand.position.x = (size.x - WIDTH) / 2 - 5;

    addAll(
      [
        statusLand,
        playland,
      ],
    );
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (gameStates == GameStates.none) {
      playAgain();
    } else if (gameStates == GameStates.paused) {
      pauseResumeGame();
    } else {
      rotate();
    }
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;

    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);
    final isArrowLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isArrowRight = keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final isArrowUp = keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final isArrowDown = keysPressed.contains(LogicalKeyboardKey.arrowDown);
    final isKeyR = keysPressed.contains(LogicalKeyboardKey.keyR);

    if (isKeyDown && isSpace) {
      // playland.startOrDrop();

      return KeyEventResult.handled;
    } else if (isKeyDown && isArrowLeft) {
      playland.left();
      return KeyEventResult.handled;
    } else if (isKeyDown && isArrowRight) {
      playland.right();
      return KeyEventResult.handled;
    } else if (isKeyDown && isArrowUp) {
      playland.rotate();
      return KeyEventResult.handled;
    } else if (isKeyDown && isArrowDown) {
      playland.down(step: 3);
      return KeyEventResult.handled;
    } else if (isKeyDown && isKeyR) {
      playland.reset();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  void initTimer() {
    timer?.cancel();
    timer = null;
    timer = Timer.periodic(
      FALL_SPEED[gameProvider.level - 1],
      (timer) {
        moveDown();
      },
    );
  }

  void resetTimer() {
    timer?.cancel();
    timer = null;
  }

  void startGame() {
    if (gameStates == GameStates.running) {
      return;
    }
    gameProvider.start();
    playland.gameInit();
    AudioManager.instance.selectSound();
    AudioManager.instance.startBgm();
    overlays.remove(StartGameOverlay.keyOverlay);
    initTimer();
  }

  void playAgain() {
    if (!gameProvider.startGame) {
      return;
    }
    overlays.remove(PlayAgainOverlay.keyOverlay);
    playland.gameInit();
    initTimer();
    AudioManager.instance.stopBgm();
    AudioManager.instance.selectSound();
    AudioManager.instance.startBgm();
  }

  void pauseResumeGame() {
    if (!gameProvider.startGame) {
      return;
    }
    if (paused || gameStates == GameStates.paused) {
      gameStates = GameStates.running;
      AudioManager.instance.resumeBgm();
      initTimer();
      gameProvider.pause(false);
      resumeEngine();
    } else {
      gameStates = GameStates.paused;
      resetTimer();
      AudioManager.instance.pauseBgm();
      gameProvider.pause(true);
      pauseEngine();
    }
  }

  void pauseResumeSound() {
    if (!gameProvider.startGame) {
      return;
    }
    if (gameProvider.playSound) {
      AudioManager.instance.stopBgm();
    } else {
      AudioManager.instance.startBgm();
    }
    gameProvider.sound();
  }

  void resetGame() {
    if (!gameProvider.startGame) {
      return;
    }
    if (gameStates == GameStates.none ||
        gameStates == GameStates.reset ||
        gameStates == GameStates.paused) {
      return;
    }

    playland.reset();
  }

  void moveLeft() {
    if (!gameProvider.startGame) {
      return;
    }
    if (gameStates != GameStates.running) {
      return;
    }
    playland.left();
  }

  void moveRight() {
    if (!gameProvider.startGame) {
      return;
    }
    if (gameStates != GameStates.running) {
      return;
    }
    playland.right();
  }

  void moveDown() {
    if (!gameProvider.startGame) {
      return;
    }
    if (gameStates != GameStates.running) {
      return;
    }
    playland.down();
  }

  void rotate() {
    if (!gameProvider.startGame) {
      return;
    }
    if (gameStates != GameStates.running) {
      return;
    }
    playland.rotate();
  }

  void quickMoveDown() {
    if (!gameProvider.startGame) {
      return;
    }
    if (gameStates != GameStates.running) {
      return;
    }
    AudioManager.instance.moveSound();
    playland.down(step: 3);
  }

  void quickDrop() {
    if (!gameProvider.startGame) {
      return;
    }
    if (gameStates != GameStates.running) {
      return;
    }
    playland.drop();
  }
}
