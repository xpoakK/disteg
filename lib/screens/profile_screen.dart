import 'dart:io';
import 'dart:convert';
import 'package:disteg/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../widgets/glass_panel.dart';
import '../../widgets/profile_action_button.dart';
import 'chat_screen.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;

  const ProfileScreen({super.key, required this.userName});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _avatarFile;
  String? _avatarUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadAvatarUrl();
  }

  Future<void> _loadAvatarUrl() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _avatarUrl = prefs.getString('avatar_url');
    });
  }

  Future<String?> _uploadAvatar(File file) async {
    final uri = Uri.parse('https://cl918558.tw1.ru/api/upload_avatar.php');

    final request = http.MultipartRequest('POST', uri)
      ..fields['login'] = widget.userName
      ..files.add(
        await http.MultipartFile.fromPath('avatar', file.path),
      );

    final response = await request.send();
    final body = await response.stream.bytesToString();

    debugPrint('upload_avatar body: $body');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(body);
        if (data['success'] == true) {
          return data['avatar_url'] as String;
        } else {
          debugPrint('upload_avatar error from server: ${data['message']}');
        }
      } catch (e) {
        debugPrint('JSON decode error: $e');
      }
    } else {
      debugPrint('upload_avatar status: ${response.statusCode}');
    }

    return null;
  }

  Future<void> _pickAvatar() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;

    final file = File(picked.path);

    if (!mounted) return;
    setState(() {
      _avatarFile = file;
    });

    final url = await _uploadAvatar(file);

    if (!mounted) return;

    if (url != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatar_url', url);

      if (!mounted) return;
      setState(() {
        _avatarUrl = url;
      });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось загрузить аватар')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider avatarImage;
    if (_avatarFile != null) {
      avatarImage = FileImage(_avatarFile!);
    } else if (_avatarUrl != null && _avatarUrl!.isNotEmpty) {
      avatarImage = NetworkImage(_avatarUrl!);
    } else {
      avatarImage = const AssetImage('assets/avatars/current.jpg');
    }

    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 0) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (_, __, ___) =>
                    ChatScreen(userName: widget.userName),
                transitionsBuilder: (_, animation, __, child) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(-1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation);
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
                        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
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
                                MaterialPageRoute(builder: (context) => const SettingsScreen()),
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
                                  transitionDuration: const Duration(milliseconds: 200),
                                  pageBuilder: (_, __, ___) =>
                                      ChatScreen(userName: widget.userName),
                                  transitionsBuilder: (_, animation, __, child) {
                                    final offsetAnimation = Tween<Offset>(
                                      begin: const Offset(-1.0, 0.0),
                                      end: Offset.zero,
                                    ).animate(animation);
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