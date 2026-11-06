import 'package:audioplayers/audioplayers.dart';

class AudioService {
  // Singleton instance
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  String? currentPlayingTitle;

  // دالة لتشغيل الصوت
  Future<void> playSound(String title, String url) async {
    try {
      if (currentPlayingTitle == title) {
        await stopSound();
        return;
      }
      await _audioPlayer.stop();
      await _audioPlayer.setSourceUrl(url);
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.resume();
      currentPlayingTitle = title;
    } catch (e) {
      // تجاهل الخطأ البسيط
    }
  }

  // دالة لإيقاف الصوت
  Future<void> stopSound() async {
    await _audioPlayer.stop();
    currentPlayingTitle = null;
  }

  bool isPlaying(String title) => currentPlayingTitle == title;
  bool get hasActiveSound => currentPlayingTitle != null;
}
