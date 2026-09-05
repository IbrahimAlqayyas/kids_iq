import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kids_iq/views/splash_screen.dart';
import 'package:kids_iq/views/color_game.dart';
import 'package:kids_iq/views/animal_game.dart';

import 'package:kids_iq/views/shape_game.dart';
import 'package:kids_iq/views/missing_part_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MaterialApp(
      title: 'Kids IQ Games',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(
        fontFamily: 'PressStart',
        useMaterial3: true,
      ),
      routes: {
        '/color_game': (_) => const ColorGame(),
        '/animal_game': (_) => const AnimalGame(),
        '/shape_game': (_) => const ShapeGame(),
        '/missing_part_game': (_) => const MissingPartGame(),
      },
    ),
  );
}





