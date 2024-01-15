import 'package:tetris_game_flutter/core/utils/user_manager.dart';

class Constants {
  static final Constants _shared = Constants._initialState();

  factory Constants() {
    return _shared;
  }

  Constants._initialState();

  static int calculateMatrixRows() {
    double screenHeight = UserManagement().getScreenHeight;
    return (screenHeight / 25).ceil();
  }

  static int calculateMatrixColumns() {
    double screenWidth = UserManagement().getScreenWidth;
    return (screenWidth / 25).ceil();
  }
}

// ignore: constant_identifier_names
const LEVEL_MAX = 6;

// ignore: constant_identifier_names
const LEVEL_MIN = 1;

// ignore: non_constant_identifier_names
int GAME_PAD_MATRIX_H = 20;
// ignore: non_constant_identifier_names
int GAME_PAD_MATRIX_W = 10;

// ignore: constant_identifier_names
const FALL_SPEED = [
  Duration(milliseconds: 800),
  Duration(milliseconds: 650),
  Duration(milliseconds: 500),
  Duration(milliseconds: 370),
  Duration(milliseconds: 250),
  Duration(milliseconds: 160),
];
