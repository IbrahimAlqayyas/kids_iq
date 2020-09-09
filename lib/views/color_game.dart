import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kids_iq/music_play.dart';

class ColorGame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ColorGameState();
  }
}

class _ColorGameState extends State<ColorGame> with WidgetsBindingObserver {
  // to increment the score
  int scoreIncrement = 0;
  // Music Controller
  MusicPlay _mp = new MusicPlay();

  // Adding the state observer
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // Removing the observer
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  // Observer conditions
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);
    if (state == AppLifecycleState.paused) {
      _mp.backgroundPause();
    }
    if (state == AppLifecycleState.resumed) {
      _mp.backgroundResume();
    }
  }

  // Score Map to bool draggable or fixed
  Map<String, bool> score = {
    '🍏': false,
    '🍋': false,
    '🍅': false,
    '🍇': false,
    '🥥': false,
    '🥕': false,
  };

  // To compare the Draggable with the DragTarget
  final Map emojiAndColor = {
    '🍏': Colors.green,
    '🍋': Colors.yellow,
    '🍅': Colors.red,
    '🍇': Colors.purple,
    '🥥': Colors.brown,
    '🥕': Colors.orange
  };

  // Random seed
  int seed = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        //title: Text('Score ${score.length}/6', style: TextStyle(fontSize: 15)),
        title: Text('Score $scoreIncrement/6', style: TextStyle(fontSize: 15)),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            score = {
              '🍏': false,
              '🍋': false,
              '🍅': false,
              '🍇': false,
              '🥥': false,
              '🥕': false,
            }; // to be false
            scoreIncrement = 0;
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
                //decoration: BoxDecoration(color: Colors.pink),
                height: 75,
                //width: 80,
                child: score[emoji]
                    ? Text('✅', style: TextStyle(fontSize: 65))
                    : Draggable<String>(
                        data: emoji,
                        child: Material(
                            color: Colors.transparent,
                            child: Text(emoji, style: TextStyle(fontSize: 65))),
                        feedback: Material(
                            color: Colors.transparent,
                            child: Text(emoji, style: TextStyle(fontSize: 65))),
                        childWhenDragging: Container(),
                      ),
              );
            }).toList()
              ..shuffle(Random(seed+1)),
          ),

          /// Colors Column
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            //crossAxisAlignment: CrossAxisAlignment.end,
            children: emojiAndColor.keys.map((emoji) {
              return DragTarget<String>(
                builder: (BuildContext context, List<String> incoming,List rejected) {
                  if (score[emoji] == true) {
                    return Container(
                      alignment: Alignment.center,
                      height: 80,
                      width: 200,
                      color: Colors.transparent,
                      child: Text('Correct!', style: TextStyle(fontSize: 18),),
                    );
                  } else {
                    return Container(
                      height: 80,
                      width: 200,
                      color: emojiAndColor[emoji],
                    );
                  }
                },
                onWillAccept: (data) => data == emoji? true : false,
                onAccept: (data) {
                  setState(() {
                    scoreIncrement++;
                    score[emoji] = true;
                  });
                  if (scoreIncrement == 6) {
                    _mp.fullScorePlay();
                  } else {
                    _mp.correctPlay();
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
