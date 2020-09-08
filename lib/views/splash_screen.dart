import 'package:flutter/material.dart';
import 'package:kids_iq/music_play.dart';
import 'package:kids_iq/views/color_game.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {
  MusicPlay _mp = MusicPlay();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: new Center(
        child: RaisedButton(
            padding: EdgeInsets.all(15),
            color: Colors.redAccent,
            elevation: 10,
            child: Text(
              'Start',
              style: TextStyle(fontSize: 35, color: Colors.white),
            ),
            onPressed: () {
              _mp.backgroundPlay();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ColorGame()));
            }),
      ),
    );
  }
}
