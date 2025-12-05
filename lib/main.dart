import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/welcome/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('logged_in') ?? false;
  final savedName = prefs.getString('user_name') ?? 'Пользователь';

  runApp(DisTegApp(
    isLoggedIn: isLoggedIn,
    savedName: savedName,
  ));
}

class DisTegApp extends StatelessWidget {
  final bool isLoggedIn;
  final String savedName;

  const DisTegApp({
    super.key,
    required this.isLoggedIn,
    required this.savedName,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn
          ? ChatScreen(userName: savedName)
          : const WelcomeScreen(),
    );
  }
}