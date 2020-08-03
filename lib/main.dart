import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';

void main() {
  runApp(MaterialApp(
    home: ColorGame(),
    theme: ThemeData(fontFamily: 'PressStart'),
  ));
}

class ColorGame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ColorGameState();
  }
}

class ColorGameState extends State<ColorGame> {
  /// To shuffle
  int seed = 0;

  /// Score Map
  Map<String, bool> score = {};

  // to compare the DragTarget
  final Map emojiAndColor = {
    '🍏': Colors.green,
    '🍋': Colors.yellow,
    '🍅': Colors.red,
    '🍇': Colors.purple,
    '🥥': Colors.brown,
    '🥕': Colors.orange
  };

  /// Music Controller
  MusicPlay musicController = new MusicPlay();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title:
            Text('Score ${score.length} / 6', style: TextStyle(fontSize: 15)),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            musicController.shufflePlay();
            score.clear();
            seed++;
          });
        },
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: emojiAndColor.keys.map((emoji) {
              return Container(
                height: 65,
                child: Draggable<String>(
                    data: emoji,
                    child: score[emoji] == true
                        ? Material(
                            color: Colors.transparent,
                            child: Text('✅', style: TextStyle(fontSize: 50)))
                        : Material(
                            color: Colors.transparent,
                            child: Text(emoji, style: TextStyle(fontSize: 50))),
                    feedback: score[emoji] == true
                        ? Material(
                            color: Colors.transparent,
                            child: Text('✅', style: TextStyle(fontSize: 50)))
                        : Material(
                            color: Colors.transparent,
                            child: Text(emoji, style: TextStyle(fontSize: 50))),
                    childWhenDragging: Container()),
              );
            }).toList()
              ..shuffle(Random(seed + 2)),
          ),

          /// Colors Column
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            //crossAxisAlignment: CrossAxisAlignment.end,
            children: emojiAndColor.keys.map((emoji) {
              return DragTarget<String>(
                builder: (BuildContext context, List<String> incoming,
                    List rejected) {
                  if (score[emoji] == true) {
                    return Container(
                      alignment: Alignment.center,
                      height: 65,
                      width: 150,
                      color: Colors.white,
                      child: Text('Correct!'),
                    );
                  } else {
                    return Container(
                      height: 65,
                      width: 150,
                      color: emojiAndColor[emoji],
                    );
                  }
                },
                onWillAccept: (data) {
                  if (data == emoji) {
                    //print('Accepted');
                    return true;
                  } else {
                    //print('Rejected');
                    return false;
                  }
                }, // or (data) => data == emoji,
                onAccept: (data) {
                  setState(() {
                    score[emoji] = true;
                  });
                  if (score.length == 6) {
                    musicController.fullScoreplay();
                  } else {
                    musicController.correctPlay();
                  }
                },
              );
            }).toList()
              ..shuffle(Random(seed)),
          ),
        ],
      ),
    );
  }
}

/// Sound Effects
class MusicPlay {
  AudioCache _musicController = AudioCache();

  void backgroundPlay() {
    _musicController.loop('background.mp3');
  }

  void correctPlay() {
    _musicController.play('correct.mp3');
  }

  void shufflePlay() {
    _musicController.play('shuffle.mp3');
  }

  void fullScoreplay() {
    _musicController.play('eventually.mp3');
  }
}
