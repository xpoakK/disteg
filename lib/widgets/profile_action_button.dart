import 'package:flutter/material.dart';
import 'dart:ui';

class ProfileActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color textColor;

  const ProfileActionButton({
    super.key,
    required this.text,
    required this.onTap,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 280,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white.withValues(alpha: .25),
              border: Border.all(
                color: Colors.white.withValues(alpha: .8),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                  color: Colors.black.withValues(alpha: .15),
                ),
              ],
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}