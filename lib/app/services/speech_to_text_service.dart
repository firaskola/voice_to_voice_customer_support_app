import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextService {
  static Future<bool> initializeSpeechToText(stt.SpeechToText speech) async {
    bool available = await speech.initialize(
      onStatus: (status) {
        print("Speech-to-text status: $status");
      },
      onError: (error) {
        print("Speech-to-text error: $error");
      },
    );
    return available;
  }
}
