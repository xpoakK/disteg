import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/glass_button.dart';
import '../../widgets/input_field.dart';
import '../chat_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);

    final uri = Uri.parse('https://cl918558.tw1.ru/api/login.php');

    final response = await http.post(
      uri,
      body: {
        'login': _loginController.text,
        'password': _passwordController.text,
      },
    );

    if (!mounted) return;

    setState(() => _loading = false);

    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      final login = _loginController.text.trim();
      final userName = login.isEmpty ? 'user' : login;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('logged_in', true);
      await prefs.setString('user_name', userName);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(userName: userName),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Неверные данные')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 0) {
            Navigator.pop(context);
          }
        },
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Group.png',
                          height: 44,
                        ),
                      ],
                    ),
                    const SizedBox(height: 130),
                    const Text(
                      'Вход',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 80),
                    InputField(
                      label: 'Логин/Эл. почта',
                      controller: _loginController,
                    ),
                    const SizedBox(height: 20),
                    InputField(
                      label: 'Пароль',
                      obscure: true,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 40),
                    GlassButton.login(
                      text: _loading ? '...' : 'Войти',
                      onTap: _loading ? () {} : _login,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}