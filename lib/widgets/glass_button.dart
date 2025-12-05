import 'dart:ui';
import 'package:flutter/material.dart';

class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double width;
  final double height;
  final double fontSize;
  final double blur;
  final double borderOpacity;

  const GlassButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width = 300,
    this.height = 50,
    this.fontSize = 23,
    this.blur = 12,
    this.borderOpacity = 0.8,
  });

  factory GlassButton.login({
    required String text,
    required VoidCallback onTap,
  }) {
    return GlassButton(
      text: text,
      onTap: onTap,
      width: 260,
      height: 46,
      fontSize: 22,
      blur: 10,
      borderOpacity: 0.7,
    );
  }

  factory GlassButton.register({
    required String text,
    required VoidCallback onTap,
  }) {
    return GlassButton(
      text: text,
      onTap: onTap,
      width: 300,
      height: 50,
      fontSize: 24,
      blur: 14,
      borderOpacity: 0.9,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(33),
              color: Colors.white.withValues(alpha: .08),
              border: Border.all(
                color: Colors.white.withValues(alpha: borderOpacity),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                  color: Colors.black.withValues(alpha: .25),
                ),
              ],
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}