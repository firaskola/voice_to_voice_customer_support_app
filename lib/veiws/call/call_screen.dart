import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class TapToTalkScreen extends StatefulWidget {
  @override
  _TapToTalkScreenState createState() => _TapToTalkScreenState();
}

class _TapToTalkScreenState extends State<TapToTalkScreen> {
  bool isListening = false;
  bool isProcessing = false;
  double _circleSize = 80;
  String displayText = "Hold & Speak";

  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission();
  }

  Future<void> _requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      print("Microphone permission granted");
    } else {
      print("Microphone permission denied");
    }
  }

  void _onTapDown() async {
    if (await Permission.microphone.isGranted) {
      setState(() {
        isListening = true;
        _circleSize = 120;
        displayText = "Listening...";
      });
    } else {
      _requestMicrophonePermission();
    }
  }

  void _onTapUp() {
    setState(() {
      isListening = false;
      _circleSize = 80;
      isProcessing = true;
      displayText = "Processing...";

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isProcessing = false;
          displayText = "Hold & Speak";
        });
      });
    });
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
          const SizedBox(height: 50),
          GestureDetector(
            onTapDown: (_) => _onTapDown(),
            onTapUp: (_) => _onTapUp(),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mic,
                color: Colors.white,
                size: 40,
              ),
            ),
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
