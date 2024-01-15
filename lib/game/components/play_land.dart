import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:tetris_game_flutter/core/core.dart';
import 'package:tetris_game_flutter/game/game.dart';

class Playland extends PositionComponent
    with HasGameRef<TetrisGame>, KeyboardHandler {
  GameBlock? _current;

  final List<List<int>> _data = [];
  final List<List<int>> _mask = [];
  List<List<int>> mixed = [];
  List<Briks> briksPool = [];

  GameBlock nextBlock = GameBlock.getRandom();

  GameStates _states = GameStates.none;
  final double _fallSpeed = 1000;

  GameBlock _getNext() {
    final next = nextBlock;
    nextBlock = GameBlock.getRandom();
    game.statusLand.nextBlockComponent.nextBlock = nextBlock;
    game.statusLand.nextBlockComponent.updateNextBlock();
    return next;
  }

  @override
  void onLoad() {
    super.onLoad();
    priority = -1;
    for (int i = 0; i < GAME_PAD_MATRIX_H; i++) {
      _data.add(List.filled(GAME_PAD_MATRIX_W, 0));
      _mask.add(List.filled(GAME_PAD_MATRIX_W, 0));
    }
    _autoFall(
      enable: _states == GameStates.running,
    );

    //border
  }

  @override
  void update(double dt) {
    super.update(dt);

    dt = dt * _fallSpeed;

    // ignore: unnecessary_null_comparison
    if (_current != null || _mask != null) {
      mixed = _calculateMixedList(); // Calculate mixed list if needed
    }
  }

  @override
  void render(Canvas canvas) {
    for (var i = 0; i < GAME_PAD_MATRIX_H; i++) {
      for (var j = 0; j < GAME_PAD_MATRIX_W; j++) {
        final briks = briksPool.isEmpty
            ? Briks(
                size: Vector2(
                  game.WIDTH / GAME_PAD_MATRIX_W - 5,
                  game.HEIGHT / GAME_PAD_MATRIX_H - 5,
                ),
              )
            : briksPool.removeLast();
        briks.position = Vector2((game.WIDTH / GAME_PAD_MATRIX_W) * j + 1,
            (game.HEIGHT / GAME_PAD_MATRIX_H) * i + 1);

        if (mixed[i][j] == 1) {
          briks.normal();
        } else if (mixed[i][j] == 2) {
          briks.highlight();
        } else {
          briks.nullColor();
        }

        add(briks);
      }
    }
    briksPool.addAll(children.whereType<Briks>());
  }

  List<List<int>> _calculateMixedList() {
    List<List<int>> mixed = [];
    for (var i = 0; i < GAME_PAD_MATRIX_H; i++) {
      mixed.add(List.filled(GAME_PAD_MATRIX_W, 0));
      for (var j = 0; j < GAME_PAD_MATRIX_W; j++) {
        int value = _current?.get(j, i) ?? _data[i][j];
        if (_mask[i][j] == -1) {
          value = 0;
        } else if (_mask[i][j] == 1) {
          value = 2;
        }
        mixed[i][j] = value;
      }
    }
    return mixed;
  }

  void _autoFall({required bool enable}) {
    if (enable) {
      // Adjust the fall speed here
      _current = _current ?? _getNext();
      game.timer?.cancel();
      game.start();
    } else {
      game.timer?.cancel();
      game.timer = null;
    }
  }

  Future<void> _mixCurrentIntoData() async {
    if (_current == null) {
      return;
    }

    _autoFall(enable: false);

    _forTable((i, j) => _data[i][j] = _current?.get(j, i) ?? _data[i][j]);
    final clearLines = [];

    for (int i = 0; i < GAME_PAD_MATRIX_H; i++) {
      if (_data[i].every((d) => d == 1)) {
        clearLines.add(i);
      }
    }

    if (clearLines.isNotEmpty) {
      _states = GameStates.clear;
      if (game.gameProvider.playSfx) {
        AudioManager.instance.playSfx('clean.mp3');
      }
      for (int count = 0; count < 5; count++) {
        for (var line in clearLines) {
          _mask[line].fillRange(0, GAME_PAD_MATRIX_W, count % 2 == 0 ? -1 : 1);
        }
        await Future.delayed(const Duration(milliseconds: 50));
      }
      for (var line in clearLines) {
        _mask[line].fillRange(0, GAME_PAD_MATRIX_W, 0);
      }

      for (var line in clearLines) {
        _data.setRange(1, line + 1, _data);
        _data[0] = List.filled(GAME_PAD_MATRIX_W, 0);
      }
      game.gameProvider.addCleared(clearLines.length);
      game.gameProvider
          .addPoints(clearLines.length * game.gameProvider.level * 5);

      //up level possible when cleared
      int level = (game.gameProvider.cleared ~/ 50) + LEVEL_MIN;
      game.gameProvider.addLevel(game.gameProvider.level <= LEVEL_MAX &&
              level > game.gameProvider.level
          ? level
          : game.gameProvider.level);
    } else {
      _states = GameStates.mixing;
      _forTable((i, j) => _mask[i][j] = _current?.get(j, i) ?? _mask[i][j]);
      await Future.delayed(const Duration(milliseconds: 300));
      _forTable((i, j) => _mask[i][j] = 0);
    }
    _current = null;
    if (_data[0].contains(1)) {
      AudioManager.instance.stopBgm();
      Future.delayed(const Duration(milliseconds: 300), () {
        if (game.gameProvider.playSfx) {
          AudioManager.instance.playSfx('explosion.mp3');
        }
      });

      Future.delayed(const Duration(milliseconds: 1200), () {
        reset();
      });

      return;
    } else {
      start();
    }
  }

  void _forTable(dynamic Function(int row, int column) function) {
    for (int i = 0; i < GAME_PAD_MATRIX_H; i++) {
      for (int j = 0; j < GAME_PAD_MATRIX_W; j++) {
        final b = function(i, j);
        if (b is bool && b) {
          break;
        }
      }
    }
  }

  void clickScreenToStart() {
    if (!game.gameProvider.startGame) {
      return;
    }
    if (_states == GameStates.running) {
      rotate();
    } else if (_states == GameStates.none) {
      start();
      game.start();
      game.playBgSound();
    } else if (_states == GameStates.paused) {
      game.pause();
    }
  }

  void startOrDrop() {
    if (!game.gameProvider.startGame) {
      return;
    }
    if (_states == GameStates.running) {
      drop();
    } else if (_states == GameStates.paused || _states == GameStates.none) {
      start();
      game.start();
    }
  }

  void start() {
    if (_states == GameStates.running) {
      return;
    }
    _states = GameStates.running;
    _autoFall(enable: true);
  }

  void pause() {
    if (_states == GameStates.running) {
      _states = GameStates.paused;
    } else if (_states == GameStates.paused) {
      _states = GameStates.running;
    }
  }

  void reset() {
    if (_states == GameStates.none ||
        _states == GameStates.reset ||
        _states == GameStates.paused) {
      return;
    }
    AudioManager.instance.stopBgm();

    _states = GameStates.reset;
    if (game.gameProvider.playSfx) {
      AudioManager.instance.playSfx('start.mp3');
    }
    () async {
      int line = GAME_PAD_MATRIX_H;

      await Future.doWhile(() async {
        line--;

        for (int i = 0; i < GAME_PAD_MATRIX_W; i++) {
          _data[line][i] = 1;
        }
        await Future.delayed(const Duration(milliseconds: 50));
        return line != 0;
      });

      _current = null;

      _getNext();
      game.timer?.cancel();
      game.timer = null;
      game.gameProvider.reset();
      await Future.doWhile(() async {
        for (int i = 0; i < GAME_PAD_MATRIX_W; i++) {
          _data[line][i] = 0;
        }

        line++;
        await Future.delayed(const Duration(milliseconds: 50));

        return line != GAME_PAD_MATRIX_H;
      });

      _states = GameStates.none;
    }();
  }

  void rotate() {
    if (_states == GameStates.running) {
      final next = _current?.rotate();
      if (next != null && next.isValidInMatrix(_data)) {
        _current = next;
        if (game.gameProvider.playSfx) {
          AudioManager.instance.playSfx('rotate.mp3');
        }
      }
    }
  }

  void right() {
    if (_states == GameStates.none && game.gameProvider.level < LEVEL_MAX) {
      game.gameProvider.levelUp();
      // Add logic for right movement when not running
    } else if (_states == GameStates.running) {
      final next = _current?.right();
      if (next != null && next.isValidInMatrix(_data)) {
        _current = next;
        if (game.gameProvider.playSfx) {
          AudioManager.instance.playSfx('move.mp3');
        }
      }
    }
  }

  void left() {
    if (_states == GameStates.none && game.gameProvider.level > LEVEL_MIN) {
      game.gameProvider.levelDown();
    } else if (_states == GameStates.running) {
      final next = _current?.left();
      if (next != null && next.isValidInMatrix(_data)) {
        _current = next;
        AudioManager.instance.playSfx('move.mp3');
      }
    }
  }

  void down({
    int step = 1,
  }) {
    if (_states == GameStates.running) {
      final next = _current?.fall();
      if (next != null && next.isValidInMatrix(_data)) {
        _current = next;
      } else {
        _mixCurrentIntoData();
      }
    }
  }

  Future<void> drop() async {
    if (_states == GameStates.running) {
      for (int i = 0; i < GAME_PAD_MATRIX_H; i++) {
        final fall = _current?.fall(step: i + 1);
        if (fall != null && !fall.isValidInMatrix(_data)) {
          _current = _current?.fall(step: i);
          _states = GameStates.drop;
          if (game.gameProvider.playSfx) {
            AudioManager.instance.playSfx('sounds_drop.wav');
          }
          position.y = 102;

          await Future.delayed(const Duration(milliseconds: 100));
          _mixCurrentIntoData();
          position.y = 100;
          break;
        }
      }
    } else if (_states == GameStates.paused || _states == GameStates.none) {
      start();
    }
  }
}
