import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class VolumeController extends StatelessWidget {
  final Function() volumeUpCallback;
  final Function() volumeDownCallback;

  const VolumeController(this.volumeUpCallback, this.volumeDownCallback, {super.key});

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: onKey,
      child: Container(), // Provide a child widget here
    );
  }

  KeyEventResult onKey(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.audioVolumeUp) {
      volumeUpCallback();
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.audioVolumeDown) {
      volumeDownCallback();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}
