import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:aurora/secrets.dart';
import 'package:aurora/tts_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

Future getImageTotext(final imagePath) async {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final RecognizedText recognizedText =
      await textRecognizer.processImage(InputImage.fromFilePath(imagePath));
  String text = recognizedText.text.toString();
  return text;
}

class TextDetector extends StatefulWidget {
  const TextDetector({super.key});

  @override
  State<TextDetector> createState() => _TextDetectorState();
}

late String s = "";
String _summary = '';

final TTSService flutterTts = TTSService();

class _TextDetectorState extends State<TextDetector> {
  void speak(String ins) {
    flutterTts.speak(ins);
  }

  @override
  void initState() {
    super.initState();
    flutterTts.speak("Click at the center of screen to start text detection");
  }

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () async {
            final XFile? image =
                await picker.pickImage(source: ImageSource.camera);
            String a = await getImageTotext(image!.path);

            setState(() {
              s = a;
              _summarize(s);
              print(s);
            });
          },
          child: Container(
            margin: const EdgeInsets.all(20),
            height: 400,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 114, 206, 146),
                  Color.fromARGB(255, 132, 192, 230)
                ],
              ),
            ),
            child: const Center(
                child: Text(
              "Click Here",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w500),
            )),
          ),
        ),
      ),
    );
  }
}

Future<void> _summarize(String? article) async {
  if (article == null) return;

  try {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: API_KEY);
    final content = [
      Content.text('Summarise this article in less then 70 words. $article')
    ];
    final response = await model.generateContent(content);
    if (response.text != null) {
      flutterTts.speak(response.text!);
    }
    print(response.text);
  } catch (e) {
    print(e);
  }
}
