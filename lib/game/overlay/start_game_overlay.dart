import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tetris_game_flutter/game/tetris_game.dart';

class StartGameOverlay extends StatelessWidget {
  static String keyOverlay = "startGameOverlay";
  final TetrisGame game;
  const StartGameOverlay({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Center(
          child: InkWell(
              onTap: () {
                game.playGame();
              },
              child: const Icon(
                Icons.play_arrow,
                size: 100,
                color: Colors.black,
              )),
        ));
  }
}
