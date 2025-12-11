import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isDanger;

  const MenuItem({
    super.key,
    required this.text,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: isDanger
                ? const Color(0xFF2B1414)
                : const Color(0xFF151515),
            border: Border.all(
              color: Colors.white.withValues(alpha: .35),
              width: 1,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}