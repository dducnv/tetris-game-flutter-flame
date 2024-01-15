import 'package:flame_audio/flame_audio.dart';

class PlayAudio {
  PlayAudio._internal();
  static final PlayAudio _instance = PlayAudio._internal();
  static PlayAudio get instance => _instance;

  Future<void> init(List<String> files) async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll(files);
  }

  void startBgm({required String fileName, double? volume}) {
    if (!FlameAudio.bgm.isPlaying) {
      FlameAudio.bgm.play(fileName, volume: volume ?? 1);
    }
  }

  void resetBgm() {}

  void dispose() {
    FlameAudio.bgm.dispose();
  }

  void pauseBgm() {
    FlameAudio.bgm.pause();
  }

  void resumeBgm() {
    FlameAudio.bgm.resume();
  }

  void stopBgm() {
    FlameAudio.bgm.stop();
  }

  void playSfx(String fileName) {
    FlameAudio.play(fileName);
  }
}
