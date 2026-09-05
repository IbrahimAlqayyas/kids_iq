import 'package:flutter/material.dart';
import 'package:kids_iq/music_play.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {
  final MusicPlay _mp = MusicPlay();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    final screenSize = MediaQuery.of(context).size;
    final double buttonWidth = (screenSize.width * 0.6).clamp(180.0, 300.0);

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: buttonWidth,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              backgroundColor: Colors.redAccent,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              _mp.backgroundPlay();
              Navigator.pushReplacementNamed(context, '/color_game');
            },
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Start',
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

