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
      // backgroundColor: const Color(0xFFB3B3B3), // УБРАТЬ

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0E0E0), // верх (светлее)
              Color(0xFF505050), // низ (темнее)
            ],
          ),
        ),

        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final h = constraints.maxHeight;

              return Stack(
                children: [
                  // ЛОГО DTS (картинка). Заменишь на свою.
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

                  // Верхний текст
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
                              Text(
                                'DisTag',
                                style: const TextStyle(
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
                      padding: EdgeInsets.only(
                        bottom: h * 0.14,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _GlassButton(
                            text: 'Войти',
                             onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                                  );
                                 }
                               ),
                          const SizedBox(height: 24),
                          _GlassButton(
                            text: 'Создать',
                            onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const RegistrationScreen()),
                            );
                            }
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


/// Простейшая "стеклянная" кнопка.
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
              color: Colors.white.withValues(alpha: .03),
              border: Border.all(
                color: Colors.white.withValues(alpha: .8),
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


class _BackButtonSoft extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButtonSoft({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .15),
              blurRadius: 16,
              offset: const Offset(6, 6),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: .9),
              blurRadius: 12,
              offset: const Offset(-6, -6),
            ),
          ],
        ),
      ),
    );
  }
}



class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // ← ВАЖНО
          children: [
            // Кнопка назад
            Padding(
              padding: const EdgeInsets.only(left: 11, top: 13), // ← двигаешь тут
              child: _BackButtonSoft(
                onTap: () => Navigator.pop(context),
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                'Страница Входа',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Верхняя панель с назад + логотип + далее
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Кнопка назад (твоя)
                  _BackButtonSoft(
                    onTap: () => Navigator.pop(context),
                  ),

                  // Логотип DTS по центру (как картинка)
              
                  Image.asset(
                    'assets/images/Group.png',   // сюда положи свою картинку
                    height: 44,
                  ),

                  // Место под кнопку "Далее" (ты просил не добавлять реальную)
                  SizedBox(
                    width: 70, // такой же размер, как кнопка слева
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Заголовок
            const Text(
              'Регистрация',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 30),

            // Поля ввода
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

            // Кнопка создания
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 14),
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

// Универсальное поле
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


