import 'package:flutter/material.dart';
import 'dart:ui';

import '../widgets/glass_panel.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  final String userName;

  const SettingsScreen({
    super.key,
    required this.userName,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _showEditDialog({
    required String title,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    bool isMultiline = false,
    required VoidCallback onSave,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(title),
          content: TextField(
            controller: controller,
            obscureText: isPassword,
            maxLines: isMultiline ? 3 : 1,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
                controller.clear();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Сохранить'),
              onPressed: () {
                onSave();
                Navigator.of(context).pop();
                controller.clear();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteConfirmation() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Удалить аккаунт?'),
          content: const Text(
            'Это действие необратимо. Все ваши данные будут удалены навсегда.',
            style: TextStyle(color: Colors.red),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена', style: TextStyle(color: Colors.black)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Удалить'),
              onPressed: () {
                print("Аккаунт удален");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Настройки',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/chat_ground.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                const SizedBox(height: 20),

                _buildSectionHeader('Аккаунт'),

                _SettingsGlassCard(
                  icon: Icons.person_outline,
                  title: 'Имя пользователя',
                  subtitle: 'Изменить отображаемое имя',
                  onTap: () => _showEditDialog(
                    title: 'Имя пользователя',
                    hint: 'Введите новое имя',
                    controller: _nameController,
                    onSave: () => print("Новое имя: ${_nameController.text}"),
                  ),
                ),

                const SizedBox(height: 12),

                _SettingsGlassCard(
                  icon: Icons.email_outlined,
                  title: 'Эл. почта',
                  subtitle: 'user@example.com',
                  onTap: () => _showEditDialog(
                    title: 'Смена почты',
                    hint: 'Новый email',
                    controller: _emailController,
                    onSave: () => print("Email: ${_emailController.text}"),
                  ),
                ),

                const SizedBox(height: 12),

                _SettingsGlassCard(
                  icon: Icons.lock_outline,
                  title: 'Пароль',
                  subtitle: '********',
                  onTap: () => _showEditDialog(
                    title: 'Смена пароля',
                    hint: 'Новый пароль',
                    isPassword: true,
                    controller: _passwordController,
                    onSave: () => print("Пароль изменен"),
                  ),
                ),

                const SizedBox(height: 12),

                _SettingsGlassCard(
                  icon: Icons.edit_note,
                  title: 'Описание профиля',
                  subtitle: 'Пару слов о себе',
                  onTap: () => _showEditDialog(
                    title: 'О себе',
                    hint: 'Текст описания...',
                    isMultiline: true,
                    controller: _bioController,
                    onSave: () => print("Bio: ${_bioController.text}"),
                  ),
                ),

                const SizedBox(height: 30),
                _buildSectionHeader('Опасная зона', isDanger: true),

                _SettingsGlassCard(
                  icon: Icons.delete_forever_outlined,
                  title: 'Удалить аккаунт',
                  subtitle: 'Навсегда стереть данные',
                  isDanger: true,
                  onTap: _showDeleteConfirmation,
                ),
                
                const SizedBox(height: 80),
              ],
            ),
          ),
          
          Align(
             alignment: Alignment.bottomCenter,
             child: Padding(
                padding: const EdgeInsets.only(bottom: 55),
                child: GlassPanel(
                  height: 56,
                  width: 250,
                  borderRadius: BorderRadius.circular(28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          'assets/icons/settings.png',
                          width: 28,
                          height: 28,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 300),
                              pageBuilder: (_, __, ___) =>
                                  ChatScreen(userName: widget.userName),
                              transitionsBuilder: (_, animation, __, child) {
                                final offsetAnimation = Tween<Offset>(
                                  begin: const Offset(1.0, 0.0), // Changed to 1.0 (From Right)
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOut,
                                ));
                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/icons/chat.png',
                          width: 28,
                          height: 28,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                             Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 300),
                                pageBuilder: (_, __, ___) => ProfileScreen(
                                  userName: widget.userName,
                                ),
                                transitionsBuilder: (_, animation, __, child) {
                                  final offsetAnimation = Tween<Offset>(
                                    begin: const Offset(1.0, 0.0), // Changed to 1.0 (From Right)
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeInOut,
                                  ));
                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                        },
                        child: Image.asset(
                          'assets/icons/profile.png',
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ],
                  ),
                ),
             ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool isDanger = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: isDanger ? Colors.redAccent : Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsGlassCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDanger;
  final double blurStrength = 10.0;

  const _SettingsGlassCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurStrength, sigmaY: blurStrength),
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white.withValues(alpha: 0.15),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDanger
                          ? Colors.red.withValues(alpha: 0.3)
                          : Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: isDanger ? Colors.redAccent : Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDanger ? Colors.redAccent : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.white54,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
