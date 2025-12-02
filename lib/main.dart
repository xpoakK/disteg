import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? firstLaunch;
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool("seen_welcome") ?? false;
    setState(() => firstLaunch = !seen);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme_mode') ?? 'system';
    setState(() {
      _themeMode = theme == 'light'
          ? ThemeMode.light
          : theme == 'dark'
          ? ThemeMode.dark
          : ThemeMode.system;
    });
  }

  Future<void> _setTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final val = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
        ? 'dark'
        : 'system';
    await prefs.setString('theme_mode', val);
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    if (firstLaunch == null) {
      return const MaterialApp(
        home: Scaffold(body: SizedBox()),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        cardColor: Colors.white,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFF0F1115),
        cardColor: const Color(0xFF111317),
        useMaterial3: true,
      ),
      home: SafeArea(
        child: firstLaunch!
            ? WelcomeScreen(
          onContinue: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool("seen_welcome", true);
            setState(() => firstLaunch = false);
          },
        )
            : HomeScreen(
          onThemeChange: _setTheme,
          currentThemeMode: _themeMode,
        ),
      ),
    );
  }
}
