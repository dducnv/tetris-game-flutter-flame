import 'package:flutter/material.dart';
import 'package:tetris_game_flutter/game/tetris_game.dart';

class PlayingGameOverlay extends StatelessWidget {
  static const String overlayName = 'playingOverlay';
  final TetrisGame gameRef;
  const PlayingGameOverlay({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: const Stack(children: [
        Positioned(bottom: 0, child: SizedBox.shrink()),
      ]),
    );
  }
}
