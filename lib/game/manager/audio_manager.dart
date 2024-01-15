import 'package:tetris_game_flutter/core/core.dart';
import 'package:tetris_game_flutter/game/game.dart';

class AudioManager {
  AudioManager._internal();
  static final AudioManager _instance = AudioManager._internal();
  static AudioManager get instance => _instance;

  final GameProvider _gameProvider = GameProvider();
  void initAudio() {
    PlayAudio.instance.init(
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
  }

  void startBgm() {
    if (_gameProvider.playSound) {
      PlayAudio.instance.startBgm(fileName: 'theme_song.mp3');
    }
  }

  void stopBgm() {
    PlayAudio.instance.stopBgm();
  }

  void pauseBgm() {
    PlayAudio.instance.pauseBgm();
  }

  void resumeBgm() {
    PlayAudio.instance.resumeBgm();
  }

  void cleanSound() {
    if (_gameProvider.playSound) {
      PlayAudio.instance.playSfx('clean.mp3');
    }
  }

  void dropSound() {
    if (_gameProvider.playSound) {
      PlayAudio.instance.playSfx('sounds_drop.wav');
    }
  }

  void selectSound() {
    if (_gameProvider.playSound) {
      PlayAudio.instance.playSfx('sounds_select.wav');
    }
  }

  void moveSound() {
    if (_gameProvider.playSound) {
      PlayAudio.instance.playSfx('move.mp3');
    }
  }

  void rotateSound() {
    if (_gameProvider.playSound) {
      PlayAudio.instance.playSfx('rotate.mp3');
    }
  }

  void startSound() {
    if (_gameProvider.playSound) {
      PlayAudio.instance.playSfx('start.mp3');
    }
  }

  void explosionSound() {
    if (_gameProvider.playSound) {
      PlayAudio.instance.playSfx('explosion.mp3');
    }
  }

  void dispose() {
    PlayAudio.instance.dispose();
  }
}
