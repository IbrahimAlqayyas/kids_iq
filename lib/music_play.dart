import 'package:audioplayers/audio_cache.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

/// Sound Effects
class MusicPlay {
  final AudioCache _audioCache = AudioCache();
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  void backgroundPlay() async {
    print('/////////////////   Background Play Method   /////////////////');
    await _assetsAudioPlayer.open(Audio("assets/audios/background.mp3"));
  }

  void backgroundPause() async {
    print('/////////////////   Background Pause Method   /////////////////');
    await _assetsAudioPlayer.pause();
  }

  void backgroundResume() async {
    print('/////////////////   Background Resume Method   /////////////////');
    await _assetsAudioPlayer.play();
  }

  void correctPlay() async {
    await _audioCache.play("audios/correct.mp3");
  }

  void shufflePlay() async{
    await _audioCache.play("audios/shuffle.mp3");
  }

  void fullScorePlay() async{
    await _audioCache.play("audios/kidscheering.mp3");
  }
}
