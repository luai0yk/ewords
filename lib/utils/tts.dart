import 'package:flutter_tts/flutter_tts.dart';

class TTS {
  static FlutterTts? _flutterTts;

  // Lazy singleton getter
  static FlutterTts get instance {
    _flutterTts ??= FlutterTts();
    return _flutterTts!;
  }
}
