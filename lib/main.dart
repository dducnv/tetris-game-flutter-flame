import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tetris_game_flutter/game/tetris_game.dart';
import 'package:tetris_game_flutter/game/widgets/playing_game_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // <--- This line
      title: 'Tetris Game',
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaler: const TextScaler.linear(1.0)),
          child: SafeArea(child: child!),
        );
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: Colors.yellow,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 4,
              ),
              SizedBox(
                height: 485,
                width: 375,
                child: Row(
                  children: [
                    Container(
                      width: 257,
                      height: 479,
                      color: const Color(0xFF9EAD86),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFF9EAD86),
                              border:
                                  Border.all(color: Colors.black, width: 1.5)),
                          child: GameWidget(
                            game: TetrisGame(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                            height: 479, color: const Color(0xFF9EAD86))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.all(0),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.pause, color: Colors.white),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.all(0),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.volume_mute_sharp,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.all(0),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.refresh, color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            height: 100,
                            width: 100,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {},
                                child: const Text(""))),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.all(0),
                                    minimumSize: const Size(0, 0),
                                    maximumSize: const Size(30, 30)),
                                onPressed: () {},
                                child: const SizedBox.shrink(),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          padding: const EdgeInsets.all(0),
                                          minimumSize: const Size(0, 0),
                                          maximumSize: const Size(30, 30)),
                                      onPressed: () {},
                                      child: const SizedBox.shrink()),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          padding: const EdgeInsets.all(0),
                                          minimumSize: const Size(0, 0),
                                          maximumSize: const Size(30, 30)),
                                      child: const SizedBox.shrink()),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: const EdgeInsets.all(0),
                                      minimumSize: const Size(0, 0),
                                      maximumSize: const Size(30, 30)),
                                  onPressed: () {},
                                  child: const SizedBox.shrink()),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Text(
                      "Make by dduc with all my heart ❤️",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
