import 'package:audioplayers/audioplayers.dart';

class MusicPlay {
  static final MusicPlay _instance = MusicPlay._internal();
  factory MusicPlay() => _instance;
  MusicPlay._internal();

  final AudioPlayer _bgPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  bool _isInitialized = false;

  Future<void> _initAudio() async {
    if (_isInitialized) return;

    await _bgPlayer.setAudioContext(AudioContext(
      android: const AudioContextAndroid(
        usageType: AndroidUsageType.media,
        contentType: AndroidContentType.music,
        audioFocus: AndroidAudioFocus.gain,
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: {AVAudioSessionOptions.mixWithOthers},
      ),
    ));
    await _bgPlayer.setReleaseMode(ReleaseMode.loop);

    await _sfxPlayer.setAudioContext(AudioContext(
      android: const AudioContextAndroid(
        usageType: AndroidUsageType.assistanceSonification,
        contentType: AndroidContentType.sonification,
        audioFocus: AndroidAudioFocus.none,
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: {AVAudioSessionOptions.mixWithOthers},
      ),
    ));

    _isInitialized = true;
  }

  Future<void> backgroundPlay() async {
    await _initAudio();
    if (_bgPlayer.state != PlayerState.playing) {
      await _bgPlayer.play(AssetSource('audios/background.mp3'));
    }
  }

  Future<void> backgroundPause() async {
    if (_bgPlayer.state == PlayerState.playing) {
      await _bgPlayer.pause();
    }
  }

  Future<void> backgroundStop() async {
    await _bgPlayer.stop();
  }

  Future<void> backgroundResume() async {
    await _initAudio();
    if (_bgPlayer.state == PlayerState.paused) {
      await _bgPlayer.resume();
    } else if (_bgPlayer.state != PlayerState.playing) {
      await _bgPlayer.play(AssetSource('audios/background.mp3'));
    }
  }

  Future<void> correctPlay() async {
    await _initAudio();
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('audios/correct.mp3'));
  }

  Future<void> shufflePlay() async {
    await _initAudio();
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('audios/shuffle.mp3'));
  }

  Future<void> fullScorePlay() async {
    await _initAudio();
    await _sfxPlayer.stop();
    await _sfxPlayer.play(AssetSource('audios/kidscheering.mp3'));
  }

  void dispose() {
    _bgPlayer.dispose();
    _sfxPlayer.dispose();
  }
}


