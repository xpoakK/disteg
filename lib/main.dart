import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const DisTegApp());
}

class DisTegApp extends StatelessWidget {
  const DisTegApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DisTegScreen(),
    );
  }
}

class DisTegScreen extends StatelessWidget {
  const DisTegScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0E0E0),
              Color(0xFF505050),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final h = constraints.maxHeight;

              return Stack(
                children: [
                  // Нижнее большое лого
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: h * 0.01),
                      child: SizedBox(
                        height: h * 0.55,
                        child: Image.asset(
                          'assets/images/logo_giant.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  // Верхний текст и лого
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 11),
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Image.asset(
                                  'assets/images/Group.png',
                                  height: 44,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'DisTag',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 23),

                          const Text(
                            'Новый мессенджер,\n'
                                'собравший в себе все самые\n'
                                'лучшие функции',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.3,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Кнопки
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: h * 0.14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _GlassButton(
                            text: 'Войти',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              );
                            },
                          ),

                          const SizedBox(height: 24),

                          _GlassButton(
                            text: 'Создать',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const RegistrationScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Стеклянная кнопка
class _GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _GlassButton({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 225,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(33),
              color: Colors.white.withOpacity(.03),
              border: Border.all(
                color: Colors.white.withOpacity(.8),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                  color: Colors.black.withOpacity(.25),
                ),
              ],
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 23,
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

// ==========================
//        LOGIN SCREEN
// ==========================
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Верхняя панель — только логотип
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/Group.png',
                    height: 44,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Вход',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  _InputField(label: 'Логин\\Эл. почта'),
                  const SizedBox(height: 20),
                  _InputField(label: 'Пароль', obscure: true),
                ],
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 35, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              onPressed: () {},
              child: const Text(
                'Войти',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ==========================
//     REGISTRATION SCREEN
// ==========================
class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Верхняя панель — только логотип
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/Group.png',
                    height: 44,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Регистрация',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  _InputField(label: 'Логин'),
                  const SizedBox(height: 20),
                  _InputField(label: 'Имя'),
                  const SizedBox(height: 20),
                  _InputField(label: 'Эл. почта'),
                  const SizedBox(height: 20),
                  _InputField(label: 'Пароль', obscure: true),
                ],
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 35, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              onPressed: () {},
              child: const Text(
                'Создать',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Поле ввода
class _InputField extends StatelessWidget {
  final String label;
  final bool obscure;

  const _InputField({
    required this.label,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFE6E6E6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
