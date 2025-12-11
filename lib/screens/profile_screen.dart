import 'dart:io';
import 'package:dis_tag_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/glass_panel.dart';
import '../../widgets/profile_action_button.dart';
import 'chat_screen.dart';
import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;

  const ProfileScreen({super.key, required this.userName});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _avatarFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAvatar() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;

    setState(() {
      _avatarFile = File(picked.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ImageProvider avatarImage = _avatarFile != null
        ? FileImage(_avatarFile!)
        : const AssetImage('assets/avatars/no-avatar-user.png') as ImageProvider;

    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 0) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (_, __, ___) =>
                    ChatScreen(userName: widget.userName),
                transitionsBuilder: (_, animation, __, child) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(-1.0, 0.0),
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
          }
        },
        child: Stack(
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
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: avatarImage,
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: _pickAvatar,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: .9),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                    color: Colors.black.withValues(alpha: .25),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add_a_photo_outlined,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    widget.userName,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 40),

                  ProfileActionButton(
                    text: 'Редактировать профиль',
                    onTap: () {},
                  ),
                  const SizedBox(height: 18),

                  ProfileActionButton(
                    text: 'Избранное',
                    onTap: () {},
                  ),
                  const SizedBox(height: 18),

                  ProfileActionButton(
                    text: 'Описание',
                    onTap: () {},
                  ),
                  const SizedBox(height: 18),

                  ProfileActionButton(
                    text: 'Выйти из аккаунта',
                    textColor: Colors.red,
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                            (route) => false,
                      );
                    },
                  ),

                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: GlassPanel(
                      height: 56,
                      width: 250,
                      borderRadius: BorderRadius.circular(28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 300),
                                  pageBuilder: (_, __, ___) => SettingsScreen(userName: widget.userName),
                                  transitionsBuilder: (_, animation, __, child) {
                                    final offsetAnimation = Tween<Offset>(
                                      begin: const Offset(-1.0, 0.0),
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
                                      begin: const Offset(-1.0, 0.0),
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
                            onTap: () {},
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}