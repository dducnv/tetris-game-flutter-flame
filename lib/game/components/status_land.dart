import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:tetris_game_flutter/game/components/components.dart';
import 'package:tetris_game_flutter/game/tetris_game.dart';

class StatusLand extends PositionComponent with HasGameRef<TetrisGame> {
  NextBlockComponent nextBlockComponent = NextBlockComponent();

  @override
  FutureOr<void> onLoad() {
    TextPaint textPaint = TextPaint(
      style: const TextStyle(
        color: Colors.black26,
        fontSize: 15,
      ),
    );
    nextBlockComponent.position = Vector2(0, 15);

    add(
      TextComponent(
        text: 'Next',
        textRenderer: textPaint,
        position: Vector2(10, 5),
      ),
    );

    add(nextBlockComponent);

    return super.onLoad();
  }
}

class NextBlockComponent extends PositionComponent with HasGameRef<TetrisGame> {
  NextBlockComponent() : super();
  List<List<int>> _data = [];
  List<Briks> briksPool = [];
  late GameBlock nextBlock;
  @override
  FutureOr<void> onLoad() {
    nextBlock = game.playland.nextBlock;
    _data = [List.filled(4, 0), List.filled(4, 0)];
    return super.onLoad();
  }

  void updateNextBlock() {
    _data = [List.filled(4, 0), List.filled(4, 0)];
    final next = BLOCK_SHAPES[nextBlock.type]!;
    for (var i = 0; i < next.length; i++) {
      for (var j = 0; j < next[i].length; j++) {
        if (next[i][j] == 1) {
          _data[i][j] = next[i][j];
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    for (var i = 0; i < _data.length; i++) {
      for (var j = 0; j < _data[i].length; j++) {
        final briks = briksPool.isEmpty
            ? Briks(
                size: Vector2(
                  100 / 4 - 5,
                  100 / 4 - 5,
                ),
              )
            : briksPool.removeLast();
        briks.position = Vector2((100 / 4) * j + 1, (100 / 4) * i + 1);
        if (_data[i][j] == 1) {
          briks.normal();
        } else {
          briks.nullColor();
        }
        add(briks);
      }
    }
    briksPool.addAll(children.whereType<Briks>());
  }
}
