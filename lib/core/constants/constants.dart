import 'package:flutter/material.dart';
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
