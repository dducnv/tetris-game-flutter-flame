import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tetris_game_flutter/game/game.dart';

class ScoreGameOverlay extends StatelessWidget {
  static String keyOverlay = "scoreGameOverlay";
  final TetrisGame game;
  const ScoreGameOverlay({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: game.gameProvider,
        child: Padding(
          padding: EdgeInsets.only(top: game.size.y * 0.025),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: game.WIDTH,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Selector<GameProvider, int>(
                            selector: (_, provider) => provider.points,
                            builder: (_, points, __) => Column(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Points",
                                  style: GoogleFonts.getFont(
                                    'Chakra Petch',
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                DigitalNumber(
                                  value: points,
                                  height: 15,
                                  color: Colors.black,
                                  padLeft: 5,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Selector<GameProvider, int>(
                            selector: (_, provider) => provider.cleared,
                            builder: (_, cleared, __) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Cleans",
                                  style: GoogleFonts.getFont(
                                    'Chakra Petch',
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                DigitalNumber(
                                  value: cleared,
                                  height: 15,
                                  color: Colors.black,
                                  padLeft: 5,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Selector<GameProvider, int>(
                            selector: (_, provider) => provider.level,
                            builder: (_, level, __) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Level",
                                  style: GoogleFonts.getFont(
                                    'Chakra Petch',
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                DigitalNumber(
                                  value: level,
                                  height: 15,
                                  color: Colors.black,
                                  padLeft: 5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ));
  }
}
