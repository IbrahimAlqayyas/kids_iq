import 'package:flutter/material.dart';
import 'package:kids_iq/views/splash_screen.dart';
import 'package:kids_iq/views/color_game.dart';

void main() {
  runApp(
      MaterialApp(
        title: 'Kids IQ Games',
        home: SplashScreen(),
        theme: ThemeData(fontFamily: 'PressStart'),
        routes: {
          '/color_game' : (_) => ColorGame()
        },
  ));
}




