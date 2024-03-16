import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _tts = FlutterTts();

  Future<void> initTts() async {
    await _tts.setLanguage('en-US'); // Set the language for text-to-speech
    await _tts.setPitch(1.0); // Set the pitch of the speech output
    await _tts.setSpeechRate(0.5); // Set the speech rate (0.0 to 2.0)
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  void stop() {
    _tts.stop();
  }
}
