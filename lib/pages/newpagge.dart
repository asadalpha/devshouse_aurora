import 'dart:async';

import 'package:aurora/objectDetectScreen.dart';
import 'package:aurora/tts_service.dart';
import 'package:aurora/tts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:music_visualizer/music_visualizer.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  @override
  TTSService flutterTts = TTSService();

  Timer? _timer;
  Future<void> speakInstruction(String instruction) async {
    await flutterTts.speak(instruction);
  }

  @override
  void initState() {
    super.initState();
    // speakInstruction(
    //     "Click on the bottom portion of the screen to start detection");

    Future.delayed(const Duration(seconds: 1), () {
      speakInstruction(
          "Click on the bottom portion of the screen to start detection");
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Container(
                  child: Padding(
            padding: const EdgeInsets.only(top: 160.0),
            child: Wave(),
          ))),
          // Container(
          //     margin: EdgeInsets.only(left: 20, right: 20),
          //     height: 400,
          //     width: double.infinity,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(12),
          //         border: Border.all(width: 1.2, color: Colors.black)),
          //     child: Center(
          //       child: Text(
          //         "Click Here",
          //         style: TextStyle(fontSize: 20),
          //       ),
          //     ))
          GestureDetector(
            onTap: () {
              flutterTts.stop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NavigationScreen()),
              );
            },
            child: Column(
              children: [
                Container(
                  height: 400,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 114, 206, 146),
                        Color.fromARGB(255, 132, 192, 230)
                      ],
                    ),
                  ),
                  child: Center(
                      child: Text(
                    "Click Here to start detection",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500),
                  )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Wave extends StatelessWidget {
  final List<Color> colors = [
    const Color.fromARGB(255, 209, 138, 138),
    const Color.fromARGB(255, 152, 210, 156),
    const Color.fromARGB(255, 162, 181, 209),
    const Color.fromARGB(255, 191, 134, 124)
  ];

  final List<int> duration = [900, 700, 600, 800, 500];

  Wave({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MusicVisualizer(
        barCount: 15,
        colors: colors,
        duration: duration,
      ),
    );
  }
}
