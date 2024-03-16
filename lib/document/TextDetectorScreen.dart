import 'package:aurora/tts_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

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

final TTSService flutterTts = TTSService();

class _TextDetectorState extends State<TextDetector> {
  void speak() {
    flutterTts.speak(s);
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
              print(s);
              speak();
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
