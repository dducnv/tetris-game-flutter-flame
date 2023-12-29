import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/palette.dart';

class TetrisGame extends FlameGame {
  final int columns = 20, rows = 10;

  late final CameraComponent cam;
  late final Vector2 screenSize = Vector2(234, 457);
  @override
  Color backgroundColor() => const Color(0xFF9EAD86);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    cam = CameraComponent.withFixedResolution(
        width: screenSize.x, height: screenSize.y);

    cam.viewfinder.anchor = Anchor.topLeft;
    add(cam);

    for (int i = 0; i < columns; i++) {
      for (int j = 0; j < rows; j++) {
        final square = SpriteComponent(
          sprite: await loadSprite('square.png'),
          size: Vector2(screenSize.x / 10 + 3, screenSize.y / 20 + 3),
          position: Vector2(
            screenSize.x / 10 * j,
            screenSize.y / 20 * i,
          ),
        );
        add(square);
      }
    }
  }
}
