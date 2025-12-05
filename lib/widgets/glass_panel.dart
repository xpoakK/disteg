import 'dart:ui';
import 'package:flutter/material.dart';

class GlassPanel extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BorderRadius borderRadius;
  final double blur;
  final double backgroundOpacity;
  final double borderOpacity;
  final double borderWidth;
  final Color borderColor;

  const GlassPanel({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.padding,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.blur = 14,
    this.backgroundOpacity = 0.25,
    this.borderOpacity = 0.75,
    this.borderWidth = 1,
    this.borderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          height: height,
          width: width,
          padding: padding ?? const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: Colors.white.withValues(alpha: backgroundOpacity),
            border: Border.all(
              color: borderColor.withValues(alpha: borderOpacity),
              width: borderWidth,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}