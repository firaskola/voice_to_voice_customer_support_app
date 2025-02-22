import 'package:conversai/app/constants/constants.dart';
import 'package:conversai/app/helpers/cloud_firestore_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:conversai/app/helpers/permissions_helper.dart';
import 'package:conversai/app/services/speech_to_text_service.dart';
import 'package:conversai/app/services/text_to_speech_service.dart';
import 'package:conversai/utils/custom_nav_drawer.dart';
import 'package:conversai/utils/mic_button.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'dart:convert';

class TapToTalkScreen extends StatefulWidget {
  TapToTalkScreen({super.key});

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
  List<Map<String, String>> chatMessages = []; // Stores current chat messages
  String currentChatId = ""; // Tracks the current chat ID
  final FirestoreHelper _firestoreHelper = FirestoreHelper();
  final User? _user = FirebaseAuth.instance.currentUser; // Get current user

  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission();
    _initializeTts();
    _initializeSpeechToText();
    _startNewChat(); // Start a new chat when the screen loads
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

  // Start a new chat
  Future<void> _startNewChat() async {
    if (_user == null) {
      print("User not logged in");
      return;
    }

    final chatId = await _firestoreHelper.createNewChat(_user!.uid);
    setState(() {
      currentChatId = chatId;
      chatMessages.clear(); // Clear the chat screen
    });
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
      if (_user == null) {
        throw Exception("User not logged in");
      }

      // Add the user's prompt to Firestore
      await _firestoreHelper.addMessage(
        _user!.uid,
        currentChatId,
        "user",
        transcription,
      );

      // Send the transcription to OpenAI API
      final responseText = await _getOpenAIResponse(transcription);

      // Add the assistant's response to Firestore
      await _firestoreHelper.addMessage(
        _user.uid,
        currentChatId,
        "assistant",
        responseText,
      );

      // Update the chat UI
      setState(() {
        chatMessages.add({"role": "user", "message": transcription});
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
    const apiKey =
        ""; // Replace with your OpenAI API key
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
        backgroundColor: kPrimaryColor,
        foregroundColor: kPrimaryLightColor,
        title: const Text(
          "Voice Chat",
          style: TextStyle(
            fontStyle: FontStyle.normal,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      drawer: const NavDrawer(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: chatMessages.isEmpty
                ? const Center(
                    child: Text(
                      "Press and hold the mic button below and speak.",
                      textAlign: TextAlign.center, // Center-align the text
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: chatMessages.length,
                    itemBuilder: (context, index) {
                      final message = chatMessages[index];
                      final isUser = message["role"] == "user";
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isUser
                                ? kPrimaryColor
                                : kPrimaryLightColor, // Use kPrimaryColor and kPrimaryLightColor
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            message["message"]!,
                            style: TextStyle(
                              color: isUser
                                  ? Colors.white
                                  : Colors
                                      .black, // Adjust text color for visibility
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: kPrimaryLightColor,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayText,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor),
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
