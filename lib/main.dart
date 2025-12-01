import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DistegApp());
}

class DistegApp extends StatelessWidget {
  const DistegApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Disteg",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
