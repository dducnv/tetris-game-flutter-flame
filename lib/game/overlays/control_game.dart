import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tetris_game_flutter/game/game.dart';

class ControlGame extends StatelessWidget {
  static String keyOverlay = "controlGameOverlay";
  final TetrisGame game;
  const ControlGame({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: game.gameProvider,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ((MediaQuery.of(context).size.width - game.WIDTH) / 2),
            vertical: 45),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Selector<GameProvider, bool>(
                          selector: (_, provider) => provider.isPause,
                          builder: (_, isPause, __) => Row(
                            children: [
                              Icon(
                                Icons.pause,
                                color: isPause
                                    ? Colors.black
                                    : const Color(0xFF8B9876),
                              ),
                              const Text('/'),
                              Icon(
                                Icons.play_arrow,
                                color: isPause
                                    ? const Color(0xFF8B9876)
                                    : Colors.black,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          focusColor: Colors.black,
                          hoverColor: Colors.black,
                          onTap: () {
                            game.pauseResumeGame();
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Selector<GameProvider, bool>(
                          selector: (_, provider) => provider.playSound,
                          builder: (_, soundOff, __) => Row(
                            children: [
                              Icon(
                                Icons.volume_down_rounded,
                                color: soundOff
                                    ? Colors.black
                                    : const Color(0xFF8B9876),
                              ),
                              const Text('/'),
                              Icon(
                                Icons.volume_mute_rounded,
                                color: soundOff
                                    ? const Color(0xFF8B9876)
                                    : Colors.black,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          focusColor: Colors.black,
                          hoverColor: Colors.black,
                          onTap: () {
                            game.pauseResumeSound();
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Reset",
                      style: GoogleFonts.getFont(
                        'Chakra Petch',
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    InkWell(
                      focusColor: Colors.black,
                      hoverColor: Colors.black,
                      onTap: () {
                        game.resetGame();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.red[700]!,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50))),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
