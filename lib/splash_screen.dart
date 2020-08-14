import 'package:flutter/material.dart';
import 'package:try_draggable_ibrahim_app/music_play.dart';
import 'package:try_draggable_ibrahim_app/color_game.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {

  MusicPlay mp = MusicPlay();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: new Center(
        child: RaisedButton(
          padding: EdgeInsets.all(15),
          color: Colors.redAccent,
          elevation: 10,
            child: Text ('Start' , style: TextStyle(
            fontSize: 35,
            color: Colors.white
          ),),
          onPressed: () {
            mp.backgroundPlay();
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => ColorGame()
            ));
          }
        ),
      ),
    );
  }

}