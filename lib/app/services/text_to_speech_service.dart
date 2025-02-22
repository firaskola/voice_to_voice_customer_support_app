import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  static Future<void> initializeTts(FlutterTts flutterTts) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  static Future<void> speak(FlutterTts flutterTts, String text) async {
    await flutterTts.speak(text);
  }
}
