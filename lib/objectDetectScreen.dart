import 'dart:async';

import 'package:aurora/painter/coordinates.dart';
import 'package:aurora/painter/detectorView.dart';
import 'package:aurora/tts_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'painter/objectPainter.dart';
import 'utils/utils.dart';

class ObjectDetectorView extends StatefulWidget {
  @override
  State<ObjectDetectorView> createState() => _ObjectDetectorView();
}

class _ObjectDetectorView extends State<ObjectDetectorView> {
  ObjectDetector? _objectDetector;
  DetectionMode _mode = DetectionMode.stream;
  bool _canProcess = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  Timer? _timer;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;
  int _option = 0;
  int count = 0;
  List<String> _detectedObjectNames = [];
  final TTSService _ttsService = TTSService(); //
  final _options = {
    'default': '',
    'object_custom': 'object_labeler.tflite',
  };

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1500), (_) {
      _speakDetectedObjects();
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _speakDetectedObjects() {
    if (_detectedObjectNames.isNotEmpty) {
      final distinctObjectNames = _detectedObjectNames.toSet().toList();
      _detectedObjectNames = distinctObjectNames;
      final detectedObjectsString = _detectedObjectNames.join(', ');
      _ttsService.speak(detectedObjectsString);
      count = 0;
    }
  }

  @override
  void dispose() {
    _canProcess = false;
    _objectDetector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        DetectorView(
          title: 'Object Detector',
          customPaint: _customPaint,
          text: _text,
          onImage: _processImage,
          initialCameraLensDirection: _cameraLensDirection,
          onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
          onCameraFeedReady: _initializeDetector,
          initialDetectionMode: DetectorViewMode.values[_mode.index],
          onDetectorViewModeChanged: _onScreenModeChanged,
        ),
        Positioned(
            top: 30,
            left: 100,
            right: 100,
            child: Row(
              children: [
                Spacer(),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: _buildDropdown(),
                    )),
                Spacer(),
              ],
            )),
      ]),
    );
  }

  Widget _buildDropdown() => DropdownButton<int>(
        value: _option,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.blue),
        underline: Container(
          height: 2,
          color: Colors.blue,
        ),
        onChanged: (int? option) {
          if (option != null) {
            setState(() {
              _option = option;
              _initializeDetector();
            });
          }
        },
        items: List<int>.generate(_options.length, (i) => i)
            .map<DropdownMenuItem<int>>((option) {
          return DropdownMenuItem<int>(
            value: option,
            child: Text(_options.keys.toList()[option]),
          );
        }).toList(),
      );

  void _onScreenModeChanged(DetectorViewMode mode) {
    switch (mode) {
      case DetectorViewMode.gallery:
        _mode = DetectionMode.single;
        _initializeDetector();
        return;

      case DetectorViewMode.liveFeed:
        _mode = DetectionMode.stream;
        _initializeDetector();
        return;
    }
  }

  void _initializeDetector() async {
    _objectDetector?.close();
    _objectDetector = null;
    print('Set detector in mode: $_mode');

    if (_option == 0) {
      // use the default model
      print('use the default model');
      final options = ObjectDetectorOptions(
        mode: _mode,
        classifyObjects: true,
        multipleObjects: true,
      );
      _objectDetector = ObjectDetector(options: options);
    } else if (_option > 0 && _option <= _options.length) {
      // use a custom model
      // make sure to add tflite model to assets/ml
      final option = _options[_options.keys.toList()[_option]] ?? '';
      final modelPath = await getAssetPath('assets/ml/$option');
      print('use custom model path: $modelPath');
      final options = LocalObjectDetectorOptions(
        mode: _mode,
        modelPath: modelPath,
        classifyObjects: true,
        multipleObjects: true,
      );
      _objectDetector = ObjectDetector(options: options);
    }
    _canProcess = true;
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (_objectDetector == null) return;
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
      _detectedObjectNames.clear(); // Clear the previous object names
    });

    final objects = await _objectDetector!.processImage(inputImage);
    final centerX = inputImage.metadata!.size.width / 2;
    for (final object in objects) {
      final left = translateX(
          object.boundingBox.left,
          inputImage.metadata!.size,
          inputImage.metadata!.size,
          inputImage.metadata!.rotation,
          _cameraLensDirection);
      final right = translateX(
          object.boundingBox.right,
          inputImage.metadata!.size,
          inputImage.metadata!.size,
          inputImage.metadata!.rotation,
          _cameraLensDirection);

      final objectCenterX = (left + right) / 2;
      final isLeftOfCenter = objectCenterX < centerX;
      var location = isLeftOfCenter ? 'left' : 'right';

      if (object.labels.isNotEmpty) {
        final label =
            object.labels.reduce((a, b) => a.confidence > b.confidence ? a : b);
        print(" confidence" + label.confidence.toString());
        if (label.confidence > 0.40) {
          count++;

          if (count == 0) {
            _detectedObjectNames.add('${label.text} on your $location ');
          }

          if (count > 0) {
            Future.delayed(const Duration(seconds: 2), () {
              _detectedObjectNames.add('${label.text} on your $location ');
            });
          }
        }
      }
    }

    print('Objects found: ${objects}\n\n');

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = ObjectDetectorPainter(
        objects,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Objects found: ${objects.length}\n\n';

      for (final object in objects) {
        text +=
            'Object:  trackingId: ${object.trackingId} - ${object.labels.map((e) => e.text)}\n\n';
      }
      _text = text;
      _customPaint = null;
    }
    _isBusy = false;

    if (mounted) {
      setState(() {});
    }
  }
}
