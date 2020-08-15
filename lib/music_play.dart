import 'package:audioplayers/audio_cache.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

/// Sound Effects
class MusicPlay {
  final AudioCache audioCache = new AudioCache();
  final assetsAudioPlayer = AssetsAudioPlayer();



  //static AudioCache _audioCache = AudioCache();
  //AudioPlayer _audioPlayer = AudioPlayer();

  void backgroundPlay() {
    //_audioPlayer.play('assets/background.mp3');
    print('===============   backgroundPlay Method   ==============');
    assetsAudioPlayer.open(Audio("assets/audios/background.mp3"));
    assetsAudioPlayer.play();
  }

  void backgroundPause() {
    //_audioCache.clear('background.mp3');
    //_audioCache.load('blank_background.mp3');
    //_audioCache.loop('blank_background.mp3');
    print('===============   backgroundPause Method   ==============');
    assetsAudioPlayer.open(Audio("assets/audios/background.mp3"));
    assetsAudioPlayer.pause();
  }

  void backgroundResume() {
    //_audioCache.clear('blank_background.mp3');
    //_audioCache.load('background.mp3');
    //_audioCache.loop('background.mp3');
    print('===============   backgroundResume Method   ==============');
    //assetsAudioPlayer.open(Audio("assets/audios/background.mp3"));
    assetsAudioPlayer.play();
  }

  void correctPlay() {
    audioCache.play("audios/correct.mp3");
    //assetsAudioPlayer.play();
    }

  void shufflePlay() {
    audioCache.play("audios/shuffle.mp3");
    //assetsAudioPlayer.play();
     }

  void fullScorePlay() {
    audioCache.play("audios/eventually.mp3");
    //assetsAudioPlayer.play();
  }

}