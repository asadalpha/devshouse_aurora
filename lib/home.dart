// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_android_volume_keydown/flutter_android_volume_keydown.dart';
import 'package:flutter/services.dart';
import 'package:aurora/tts_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  StreamSubscription<HardwareButton>? subscription;
  final TTSService _ttsService = TTSService(); // Initialize TTSService

  double currentVolume = 0;
  double initVolume = 0;
  double maxVolume = 0;
  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  final TextEditingController _textController = TextEditingController();

  Future<void> _initializeTts() async {
    await _ttsService.initTts();
  }

  void _speak(String text) {
    _ttsService.speak(text);
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter TTS'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Enter text to speak',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final text = _textController.text;
                  _speak(text);
                },
                child: Text('Speak'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
