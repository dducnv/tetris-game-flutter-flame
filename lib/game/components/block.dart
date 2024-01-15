import 'dart:math' as math;

import 'package:tetris_game_flutter/game/tetris_game.dart';

// ignore: constant_identifier_names
const BLOCK_SHAPES = {
  BlockType.I: [
    [1, 1, 1, 1]
  ],
  BlockType.L: [
    [0, 0, 1],
    [1, 1, 1],
  ],
  BlockType.J: [
    [1, 0, 0],
    [1, 1, 1],
  ],
  BlockType.Z: [
    [1, 1, 0],
    [0, 1, 1],
  ],
  BlockType.S: [
    [0, 1, 1],
    [1, 1, 0],
  ],
  BlockType.O: [
    [1, 1],
    [1, 1]
  ],
  BlockType.T: [
    [0, 1, 0],
    [1, 1, 1]
  ]
};

// ignore: constant_identifier_names
const START_XY = {
  BlockType.I: [3, 0],
  BlockType.L: [4, -1],
  BlockType.J: [4, -1],
  BlockType.Z: [4, -1],
  BlockType.S: [4, -1],
  BlockType.O: [4, -1],
  BlockType.T: [4, -1],
};

// ignore: constant_identifier_names
const ORIGIN = {
  BlockType.I: [
    [1, -1],
    [-1, 1],
  ],
  BlockType.L: [
    [0, 0]
  ],
  BlockType.J: [
    [0, 0]
  ],
  BlockType.Z: [
    [0, 0]
  ],
  BlockType.S: [
    [0, 0]
  ],
  BlockType.O: [
    [0, 0]
  ],
  BlockType.T: [
    [0, 0],
    [0, 1],
    [1, -1],
    [-1, 0]
  ],
};

enum BlockType { I, L, J, Z, S, O, T }

class GameBlock {
  final BlockType type;
  final List<List<int>> shape;
  final List<int> xy;
  final int rotateIndex;

  GameBlock(this.type, this.shape, this.xy, this.rotateIndex);

  GameBlock fall({int step = 1}) {
    return GameBlock(type, shape, [xy[0], xy[1] + step], rotateIndex);
  }

  GameBlock right() {
    return GameBlock(type, shape, [xy[0] + 1, xy[1]], rotateIndex);
  }

  GameBlock left() {
    return GameBlock(type, shape, [xy[0] - 1, xy[1]], rotateIndex);
  }

  GameBlock rotate() {
    List<List<int>> result =
        List.filled(shape[0].length, const [], growable: false);
    for (int row = 0; row < shape.length; row++) {
      for (int col = 0; col < shape[row].length; col++) {
        if (result[col].isEmpty) {
          result[col] = List.filled(shape.length, 0, growable: false);
        }
        result[col][row] = shape[shape.length - 1 - row][col];
      }
    }
    final nextXy = [
      xy[0] + ORIGIN[type]![rotateIndex][0],
      xy[1] + ORIGIN[type]![rotateIndex][1]
    ];
    final nextRotateIndex =
        rotateIndex + 1 >= ORIGIN[type]!.length ? 0 : rotateIndex + 1;

    return GameBlock(type, result, nextXy, nextRotateIndex);
  }

  bool isValidInMatrix(List<List<int>> matrix) {
    if (xy[1] + shape.length > GAME_PAD_MATRIX_H ||
        xy[0] < 0 ||
        xy[0] + shape[0].length > GAME_PAD_MATRIX_W) {
      return false;
    }
    for (var i = 0; i < matrix.length; i++) {
      final line = matrix[i];
      for (var j = 0; j < line.length; j++) {
        if (line[j] == 1 && get(j, i) == 1) {
          return false;
        }
      }
    }
    return true;
  }

  int? get(int x, int y) {
    x -= xy[0];
    y -= xy[1];
    if (x < 0 || x >= shape[0].length || y < 0 || y >= shape.length) {
      return null;
    }
    return shape[y][x] == 1 ? 1 : null;
  }

  static GameBlock fromType(BlockType type) {
    final shape = BLOCK_SHAPES[type];
    return GameBlock(type, shape!, START_XY[type]!, 0);
  }

  static GameBlock getRandom() {
    final i = math.Random().nextInt(BlockType.values.length);
    return fromType(BlockType.values[i]);
  }
}
