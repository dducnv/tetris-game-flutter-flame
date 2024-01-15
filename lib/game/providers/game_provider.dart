import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  GameProvider();

  bool _isPause = false;
  bool get isPause => _isPause;

  bool _playSound = true;
  bool get playSound => _playSound;

  bool _startGame = false;
  bool get startGame => _startGame;

  int _level = 1;
  int get level => _level;

  int _points = 0;
  int get points => _points;

  int _cleared = 0;
  int get cleared => _cleared;

  void pause(
    bool isPause,
  ) {
    _isPause = isPause;
    notifyListeners();
  }

  void sound() {
    _playSound = !_playSound;
    notifyListeners();
  }

  void start() {
    _startGame = true;
    notifyListeners();
  }

  void levelUp() {
    _level++;
    notifyListeners();
  }

  void addLevel(int level) {
    _level = level;
    notifyListeners();
  }

  void levelDown() {
    _level--;
    notifyListeners();
  }

  void addPoints(int points) {
    _points += points;
    notifyListeners();
  }

  void addCleared(int cleared) {
    _cleared += cleared;
    notifyListeners();
  }

  void reset() {
    _level = 1;
    _points = 0;
    _cleared = 0;
    notifyListeners();
  }
}
