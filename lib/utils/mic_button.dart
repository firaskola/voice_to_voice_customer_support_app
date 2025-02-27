import 'package:conversai/app/constants/constants.dart';
import 'package:flutter/material.dart';

class MicButton extends StatelessWidget {
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;

  const MicButton({required this.onTapDown, required this.onTapUp});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) => onTapUp(),
      child: Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          color: kPrimaryColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.mic,
          color: kPrimaryLightColor,
          size: 40,
        ),
      ),
    );
  }
}
