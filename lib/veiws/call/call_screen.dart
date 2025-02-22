import 'package:conversai/app/helpers/permissions_helper.dart';
import 'package:conversai/app/services/speech_to_text_service.dart';
import 'package:conversai/app/services/text_to_speech_service.dart';
import 'package:conversai/utils/mic_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'dart:convert';

class TapToTalkScreen extends StatefulWidget {
  @override
  _TapToTalkScreenState createState() => _TapToTalkScreenState();
}

class _TapToTalkScreenState extends State<TapToTalkScreen> {
  bool isListening = false;
  bool isProcessing = false;
  double _circleSize = 80;
  String displayText = "Hold & Speak";
  FlutterTts flutterTts = FlutterTts();
  stt.SpeechToText speech = stt.SpeechToText();
  String transcription = "";

  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission();
    _initializeTts();
    _initializeSpeechToText();
  }

  Future<void> _requestMicrophonePermission() async {
    await PermissionsHelper.requestMicrophonePermission();
  }

  Future<void> _initializeTts() async {
    await TextToSpeechService.initializeTts(flutterTts);
  }

  Future<void> _initializeSpeechToText() async {
    bool available = await SpeechToTextService.initializeSpeechToText(speech);
    if (available) {
      print("Speech-to-text initialized successfully");
    } else {
      print("Speech-to-text initialization failed");
    }
  }

  void _onTapDown() async {
    if (await PermissionsHelper.isMicrophonePermissionGranted()) {
      setState(() {
        isListening = true;
        _circleSize = 120;
        displayText = "Listening...";
      });

      await speech.listen(
        onResult: (result) {
          setState(() {
            transcription = result.recognizedWords;
          });
          print("Transcription: $transcription");
        },
      );
    } else {
      _requestMicrophonePermission();
    }
  }

  void _onTapUp() async {
    setState(() {
      isListening = false;
      _circleSize = 80;
      isProcessing = true;
      displayText = "Processing...";
    });

    speech.stop();

    try {
      // Send the transcription to OpenAI API
      final responseText = await _getOpenAIResponse(transcription);

      // Speak the response using TTS
      await TextToSpeechService.speak(flutterTts, responseText);

      setState(() {
        isProcessing = false;
        displayText = "Hold & Speak";
        transcription = "";
      });
    } catch (e) {
      setState(() {
        isProcessing = false;
        displayText = "Error: Tap to retry";
      });
      print("Error: $e");
    }
  }

  Future<String> _getOpenAIResponse(String prompt) async {
    const apiKey = "api key"; // Replace with your OpenAI API key
    const apiUrl = "https://api.openai.com/v1/chat/completions";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo", // or "gpt-4"
        "messages": [
          {"role": "system", "content": "You are a helpful assistant."},
          {"role": "user", "content": prompt}
        ],
        "max_tokens": 150, // Limit response length
        "temperature": 0.7, // Adjust creativity (0 = strict, 1 = creative)
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception("Failed to fetch response: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: isProcessing
                  ? _buildProcessingShape()
                  : TweenAnimationBuilder(
                      tween: Tween<double>(begin: 80, end: _circleSize),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, size, child) {
                        return Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            color: isListening ? Colors.black : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            displayText,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          if (isProcessing)
            Text(
              "Transcription: $transcription",
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          const SizedBox(height: 50),
          MicButton(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingShape() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.blue.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.blue,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }
}
