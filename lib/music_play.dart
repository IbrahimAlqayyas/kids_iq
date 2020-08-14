import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

/// Sound Effects
class MusicPlay {
  AudioCache _audioCache = AudioCache();
  AudioPlayer _audioPlayer = AudioPlayer();

  void backgroundPlay() {
    _audioCache.play('background.mp3');
  }
/*
  void backgroundPause(){
    _audioPlayer.pause();
  }

  void backgroundResume(){
    _audioPlayer.resume();
  }
*/
  void correctPlay() {
    _audioCache.play('correct.mp3');
  }

  void shufflePlay() {
    _audioCache.play('shuffle.mp3');
  }

  void fullScorePlay() {
    _audioCache.play('eventually.mp3');
  }


}