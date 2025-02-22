import 'package:conversai/app/helpers/permissions_helper.dart';
import 'package:conversai/app/services/speech_to_text_service.dart';
import 'package:conversai/app/services/text_to_speech_service.dart';
import 'package:conversai/utils/custom_nav_drawer.dart';
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
  String displayText = "Hold & Speak";
  FlutterTts flutterTts = FlutterTts();
  stt.SpeechToText speech = stt.SpeechToText();
  String transcription = "";
  List<Map<String, String>> chatMessages = []; // Stores chat history

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
      isProcessing = true;
      displayText = "Processing...";
    });

    speech.stop();

    try {
      // Add the user's prompt to the chat
      setState(() {
        chatMessages.add({"role": "user", "message": transcription});
      });

      // Send the transcription to OpenAI API
      final responseText = await _getOpenAIResponse(transcription);

      // Add the assistant's response to the chat
      setState(() {
        chatMessages.add({"role": "assistant", "message": responseText});
      });

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
    const apiKey = "your-openai-api-key"; // Replace with your OpenAI API key
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
      appBar: AppBar(
        title: Text("Voice Chat"),
      ),
      drawer: NavDrawer(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                final message = chatMessages[index];
                final isUser = message["role"] == "user";
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message["message"]!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayText,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ),
                MicButton(
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
