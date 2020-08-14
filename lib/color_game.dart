import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:try_draggable_ibrahim_app/music_play.dart';

class ColorGame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ColorGameState();
  }
}

class ColorGameState extends State <ColorGame> with WidgetsBindingObserver {

  /// Adding the state observer
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  /// Removing the observer
  @override
  void dispose(){
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  /// Music Controller
  MusicPlay _mp = new MusicPlay();

  /// Observer conditions
  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    super.didChangeAppLifecycleState(state);
    print(state);

    if (state == AppLifecycleState.paused) {
      //_mp.backgroundPause();
    }

    if(state == AppLifecycleState.resumed){
     // _mp.backgroundResume();
    }

  }

  /// Score Map
  Map<String, bool> score = {};

  /// To compare the DragTarget
  final Map emojiAndColor = {
    '🍏': Colors.green,
    '🍋': Colors.yellow,
    '🍅': Colors.red,
    '🍇': Colors.purple,
    '🥥': Colors.brown,
    '🥕': Colors.orange
  };

  /// Random seed
  int seed = 0;

  /// Background play condition
  int x = 0;

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    if (x == 0){
      //musicController.backgroundPlay();
      x++;
    }
  }


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
        title:
        Text('Score ${score.length} / 6', style: TextStyle(fontSize: 15)),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
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