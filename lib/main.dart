import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tetris_game_flutter/core/utils/utils.dart';
import 'package:tetris_game_flutter/game/overlay/overlay.dart';
import 'package:tetris_game_flutter/game/tetris_game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortraitUpOnly();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  late TetrisGame game;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    UserManagement().navigatorKey = _navigatorKey;
  }

  @override
  void dispose() {
    super.dispose();
    game.dispose();
  }

  @override
  Widget build(BuildContext context) {
    game = TetrisGame(
      screenSize: MediaQuery.of(context).size,
    );
    bool isLeftRightBusy = false;
    bool slowDown = false;
    UserManagement().getScreenHeight = MediaQuery.of(context).size.height;
    UserManagement().getScreenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false, // <--- This line
      title: 'Tetris Game',
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaler: const TextScaler.linear(1)),
          child: GestureDetector(
              onHorizontalDragUpdate: (DragUpdateDetails details) async {
                if (!isLeftRightBusy) {
                  isLeftRightBusy = true;

                  double sensitivity = 0.01;
                  double delta = details.primaryDelta! * sensitivity;

                  if (delta > 0) {
                    game.playland.right();
                  } else if (delta < 0) {
                    game.playland.left();
                  }

                  // Introduce a delay, adjust the duration as needed
                  await Future.delayed(const Duration(milliseconds: 90));

                  isLeftRightBusy = false;
                }
              },
              onVerticalDragUpdate: (DragUpdateDetails details) {
                if (details.primaryDelta! > 16) {
                  game.playland.drop();
                }
                if (!slowDown) {
                  slowDown = true;

                  double sensitivity = 0.01;
                  double delta = details.primaryDelta! * sensitivity;

                  if (delta > 0) {
                    game.playSoundMoveDown();
                    game.playland.down(step: 2);
                  }

                  Future.delayed(const Duration(milliseconds: 50), () {
                    slowDown = false;
                  });
                }
              },
              child: SafeArea(child: child!)),
        );
      },
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(0),
          color: const Color(0xFF9EAD86),
          child: GameWidget.controlled(
              initialActiveOverlays: [
                ScoreGameOverlay.keyOverlay,
                ControlGame.keyOverlay,
                StartGameOverlay.keyOverlay,
              ],
              gameFactory: () => game,
              overlayBuilderMap: {
                ControlGame.keyOverlay: (context, game) => ControlGame(
                      game: game as TetrisGame,
                    ),
                StartGameOverlay.keyOverlay: (context, game) =>
                    StartGameOverlay(
                      game: game as TetrisGame,
                    ),
                ScoreGameOverlay.keyOverlay: (context, game) =>
                    ScoreGameOverlay(
                      game: game as TetrisGame,
                    ),
              }),
        ),
      ),
    );
  }
}
