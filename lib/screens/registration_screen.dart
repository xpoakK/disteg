import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/glass_button.dart';
import '../widgets/input_field.dart';
import '../services/fcm_service.dart';
import '../utils/constants.dart';
import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _loginController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;

  Future<void> _register() async {
    setState(() => _loading = true);

    final uri = Uri.parse('$apiBaseUrl/register.php');

    final response = await http.post(
      uri,
      body: {
        'login': _loginController.text,
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      },
    );

    if (!mounted) return;

    setState(() => _loading = false);

    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      final int userId = int.tryParse(data['user_id'].toString()) ?? 0;
      final login = _loginController.text.trim();
      final userName = login.isEmpty ? 'user' : login;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('logged_in', true);
      await prefs.setString('user_name', userName);
      await prefs.setInt('user_id', userId);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(userName: userName),
        ),
      );

      // Регистрируем токен FCM
      registerFcmToken(login).catchError((e, st) {
        debugPrint('Ошибка registerFcmToken: $e\n$st');
      });
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
          if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
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
                    const SizedBox(height: 30),
                    const Text(
                      'Регистрация',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    InputField(
                      label: 'Логин',
                      controller: _loginController,
                    ),
                    const SizedBox(height: 20),
                    InputField(
                      label: 'Имя',
                      controller: _nameController,
                    ),
                    const SizedBox(height: 20),
                    InputField(
                      label: 'Эл. почта',
                      controller: _emailController,
                    ),
                    const SizedBox(height: 20),
                    InputField(
                      label: 'Пароль',
                      obscure: true,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 40),
                    GlassButton.register(
                      text: _loading ? '...' : 'Зарегистрироваться',
                      onTap: _loading ? () {} : _register,
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