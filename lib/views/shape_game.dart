import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kids_iq/music_play.dart';
import 'package:kids_iq/widgets/completion_dialog.dart';
import 'package:kids_iq/widgets/celebration_overlay.dart';

class ShapeGame extends StatefulWidget {
  const ShapeGame({super.key});

  @override
  State<ShapeGame> createState() => _ShapeGameState();
}

class _ShapeGameState extends State<ShapeGame> with WidgetsBindingObserver {
  int scoreIncrement = 0;
  bool _showCelebration = false;
  final MusicPlay _mp = MusicPlay();

  Map<String, bool> score = {
    '🔴': false,
    '🟩': false,
    '🔺': false,
    '⭐': false,
    '💎': false,
    '💜': false,
  };

  final Map<String, Color> shapeColors = {
    '🔴': Colors.redAccent,
    '🟩': Colors.green,
    '🔺': Colors.deepOrangeAccent,
    '⭐': Colors.amber.shade700,
    '💎': Colors.teal,
    '💜': Colors.purpleAccent,
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
    final shapeKeys = score.keys.toList();
    final leftList = List<String>.from(shapeKeys)..shuffle(Random(seed + 1));
    final rightList = List<String>.from(shapeKeys)..shuffle(Random(seed));

    final screenSize = MediaQuery.of(context).size;
    final double cardWidth = (screenSize.width * 0.52).clamp(160.0, 240.0);
    final double itemHeight =
        ((screenSize.height - kToolbarHeight - MediaQuery.of(context).padding.top - 20) / 7.2)
            .clamp(55.0, 80.0);
    final double emojiSize = (itemHeight * 0.95).clamp(50.0, 75.0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_outlined, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/animal_game');
              },
            ),
            const Text(
              'Game 3/3',
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
                /// Shapes Column
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: leftList.map((shape) {
                    return Container(
                      width: emojiSize,
                      height: itemHeight,
                      alignment: Alignment.center,
                      child: (score[shape] ?? false)
                          ? FittedBox(
                              fit: BoxFit.contain,
                              child: Text('✅', style: TextStyle(fontSize: itemHeight * 0.5)),
                            )
                          : Draggable<String>(
                              data: shape,
                              feedback: Material(
                                color: Colors.transparent,
                                child: SizedBox(
                                  width: emojiSize * 1.15,
                                  height: itemHeight * 1.15,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(shape),
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
                                    child: Text(shape),
                                  ),
                                ),
                              ),
                              child: SizedBox(
                                width: emojiSize,
                                height: itemHeight,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(shape),
                                ),
                              ),
                            ),
                    );
                  }).toList(),
                ),

                /// Shape Targets Column
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: rightList.map((shapeKey) {
                    final cardColor = shapeColors[shapeKey] ?? Colors.teal;

                    return DragTarget<String>(
                      builder: (BuildContext context, List<String?> candidateData,
                          List<dynamic> rejectedData) {
                        if (score[shapeKey] == true) {
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
                                  shapeKey,
                                  style: TextStyle(fontSize: itemHeight * 0.5),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      onWillAcceptWithDetails: (details) =>
                          (score[shapeKey] != true) && (details.data == shapeKey),
                      onAcceptWithDetails: (details) {
                        setState(() {
                          scoreIncrement++;
                          score[shapeKey] = true;
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
