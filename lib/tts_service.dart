import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _tts = FlutterTts();

  Future<void> initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.5);
    await _tts.setVoice({"name": "Karen", "locale": "en-AU"});
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  void stop() {
    _tts.stop();
  }
}
