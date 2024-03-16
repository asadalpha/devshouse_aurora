// ignore_for_file: unused_element

import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _tts = FlutterTts();

  Future<void> initTts() async {


    await _tts.setLanguage('en-US'); 
    await _tts.setPitch(1.0); 
    await _tts.setSpeechRate(0.65); 


  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  Future<void> setAwaitOptions() async {
    await _tts.awaitSpeakCompletion(true);
  }

  void stop() {
    _tts.stop();
  }
}
