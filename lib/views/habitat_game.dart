import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kids_iq/music_play.dart';
import 'package:kids_iq/widgets/completion_dialog.dart';
import 'package:kids_iq/widgets/celebration_overlay.dart';

class HabitatGame extends StatefulWidget {
  const HabitatGame({super.key});

  @override
  State<HabitatGame> createState() => _HabitatGameState();
}

class _HabitatGameState extends State<HabitatGame> with WidgetsBindingObserver {
  int scoreIncrement = 0;
  bool _showCelebration = false;
  final MusicPlay _mp = MusicPlay();

  Map<String, bool> score = {
    '✈️': false, // Airplane -> Sky/Cloud
    '🚢': false, // Ship -> Ocean/Sea
    '🚗': false, // Car -> Traffic Light
    '🚀': false, // Rocket -> Moon
    '🐝': false, // Bee -> Sunflower
    '🌧️': false, // Rain -> Rainbow
  };

  // Maps item emoji to its clear matching environment/target emoji
  final Map<String, String> creatureToHabitat = {
    '✈️': '☁️',
    '🚢': '🌊',
    '🚗': '🚦',
    '🚀': '🌙',
    '🐝': '🌻',
    '🌧️': '🌈',
  };

  final Map<String, Color> habitatColors = {
    '☁️': Colors.lightBlue,
    '🌊': Colors.blue,
    '🚦': Colors.redAccent,
    '🌙': Colors.indigo,
    '🌻': Colors.amber.shade700,
    '🌈': Colors.purple,
  };

  int seed = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _mp.backgroundPause();
    } else if (state == AppLifecycleState.resumed) {
      _mp.backgroundResume();
    }
  }

  @override
  Widget build(BuildContext context) {
    final creatureKeys = creatureToHabitat.keys.toList();
    final leftList = List<String>.from(creatureKeys)..shuffle(Random(seed + 1));
    final rightList = List<String>.from(creatureKeys)..shuffle(Random(seed));

    final screenSize = MediaQuery.of(context).size;
    final double cardWidth = (screenSize.width * 0.52).clamp(160.0, 240.0);
    final double itemHeight =
        ((screenSize.height - kToolbarHeight - MediaQuery.of(context).padding.top - 20) / 7.2)
            .clamp(55.0, 80.0);
    final double emojiSize = (itemHeight * 0.95).clamp(50.0, 75.0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_outlined, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/missing_part_game');
              },
            ),
            const Text(
              'Game 5/5',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            Text(
              'Score $scoreIncrement/6',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                /// Items Column
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: leftList.map((creature) {
                    return Container(
                      width: emojiSize,
                      height: itemHeight,
                      alignment: Alignment.center,
                      child: (score[creature] ?? false)
                          ? FittedBox(
                              fit: BoxFit.contain,
                              child: Text('✅', style: TextStyle(fontSize: itemHeight * 0.5)),
                            )
                          : Draggable<String>(
                              data: creature,
                              feedback: Material(
                                color: Colors.transparent,
                                child: SizedBox(
                                  width: emojiSize * 1.15,
                                  height: itemHeight * 1.15,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(creature),
                                  ),
                                ),
                              ),
                              childWhenDragging: SizedBox(
                                width: emojiSize,
                                height: itemHeight,
                                child: Opacity(
                                  opacity: 0.25,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(creature),
                                  ),
                                ),
                              ),
                              child: SizedBox(
                                width: emojiSize,
                                height: itemHeight,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(creature),
                                ),
                              ),
                            ),
                    );
                  }).toList(),
                ),

                /// Target Environments Column
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: rightList.map((creatureKey) {
                    final habitat = creatureToHabitat[creatureKey]!;
                    final cardColor = habitatColors[habitat] ?? Colors.deepPurple;

                    return DragTarget<String>(
                      builder: (BuildContext context, List<String?> candidateData,
                          List<dynamic> rejectedData) {
                        if (score[creatureKey] == true) {
                          return Container(
                            alignment: Alignment.center,
                            height: itemHeight,
                            width: cardWidth,
                            color: Colors.transparent,
                            child: const Text(
                              'Correct!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            height: itemHeight,
                            width: cardWidth,
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.15),
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  habitat,
                                  style: TextStyle(fontSize: itemHeight * 0.5),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      onWillAcceptWithDetails: (details) =>
                          (score[creatureKey] != true) && (details.data == creatureKey),
                      onAcceptWithDetails: (details) {
                        setState(() {
                          scoreIncrement++;
                          score[creatureKey] = true;
                        });
                        if (scoreIncrement == 6) {
                          _mp.fullScorePlay();
                          setState(() {
                            _showCelebration = true;
                          });
                        } else {
                          _mp.correctPlay();
                        }
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          if (_showCelebration)
            CelebrationOverlay(
              onFinished: () {
                if (mounted) {
                  showGameCompletionDialog(
                    context,
                    onPlayAgain: () {
                      Navigator.pushReplacementNamed(context, '/color_game');
                    },
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}
