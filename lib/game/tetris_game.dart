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

    AudioManager.instance.init(
      [
        'clean.mp3',
        'sounds_drop.wav',
        'sounds_select.wav',
        'move.mp3',
        'rotate.mp3',
        'start.mp3',
        'explosion.mp3',
        'theme_song.mp3'
      ],
    );

    AudioManager.instance.stopBgm();

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
    playland.clickScreenToStart();
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
      playland.startOrDrop();

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

  void playGame() {
    playland.start();
    gameProvider.start();
    start();
    AudioManager.instance.playSfx('sounds_select.wav');
    playBgSound();
    overlays.remove(StartGameOverlay.keyOverlay);
  }

  void playBgSound() {
    AudioManager.instance.startBgm(
      fileName: 'theme_song.mp3',
      volume: 0.3,
    );
  }

  void start() {
    timer?.cancel();
    timer = null;
    timer = Timer.periodic(
      FALL_SPEED[gameProvider.level - 1],
      (timer) {
        playland.down();
      },
    );
  }

  void offSound() {
    if (!gameProvider.startGame) {
      return;
    }
    if (gameProvider.playSfx) {
      AudioManager.instance.stopBgm();
    } else {
      playBgSound();
    }

    gameProvider.sound();
  }

  void playSoundMoveDown() {
    if (gameProvider.playSfx) {
      AudioManager.instance.playSfx('move.mp3');
    }
  }

  void pause() {
    if (!gameProvider.startGame) {
      return;
    }
    if (paused) {
      start();
      playland.pause();
      gameProvider.pause(false);
      resumeEngine();
    } else {
      playland.pause();
      timer?.cancel();
      timer = null;
      gameProvider.pause(true);
      pauseEngine();
    }
  }

  //remoee and dispose
  void dispose() {
    timer?.cancel();
    timer = null;
    AudioManager.instance.dispose();
  }
}
