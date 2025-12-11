import 'dart:async';
import 'dart:convert';
import 'package:dis_tag_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/chat_message.dart';
import '../../models/user_data.dart';
import '../../widgets/glass_panel.dart';
import '../../widgets/chat_bubble.dart';
import '../../widgets/message_input_bar.dart';
import '../../widgets/search_delegate.dart';
import 'profile_screen.dart';


class ChatScreen extends StatefulWidget {
  final String userName;

  const ChatScreen({
    super.key,
    required this.userName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> messages = [];
  final ScrollController scrollController = ScrollController();
  List<UserData> chatUsers = [];

  bool _loadingMessages = false;
  bool _isSearchActive = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _pollTimer;

  String? _selectedCompanionLogin;
  UserData? _selectedCompanion;

  String get companionName {
    if (_selectedCompanionLogin != null && _selectedCompanionLogin!.isNotEmpty) {
      return _selectedCompanionLogin!;
    }

    final others = messages.where((m) => !m.isMe);
    if (others.isNotEmpty) {
      return others.last.userName;
    }

    return 'Чат';
  }

  Future<List<UserData>> searchUsers(String query) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.parse(
      'https://cl918558.tw1.ru/api/get_users.php?q=$query',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return (data['users'] as List)
            .map((e) => UserData.fromJson(e))
            .toList();
      }
    }

    return [];
  }

  Future<void> loadChatUsers() async {
    final uri = Uri.parse("https://cl918558.tw1.ru/api/get_chat_users.php?login=${widget.userName}");
    final r = await http.get(uri);

    if (r.statusCode == 200) {
      final data = jsonDecode(r.body);
      if (data["success"] == true) {
        setState(() {
          chatUsers = (data["users"] as List).map((e)=>UserData.fromJson(e)).toList();
        });
      }
    }
  }

  Future<void> _openUserSearch() async {
    final selectedUser = await showSearch<UserData?>(
      context: context,
      delegate: ChatSearchDelegate(searchUsers),
    );

    if (selectedUser != null) {
      setState(() {
        _selectedCompanionLogin = selectedUser.login;
        _selectedCompanion = selectedUser;
      });
      await _loadMessages();
    }
  }

  Future<void> _openMessageSearch() async {
    final selectedMessage = await showSearch<ChatMessage?>(
      context: context,
      delegate: MessageSearchDelegate(messages),
    );

    if (selectedMessage != null) {
      // Scroll to selected message if needed
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMessages();
    loadChatUsers();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _loadMessages();
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    if (_loadingMessages) return;

    if (_selectedCompanionLogin == null || _selectedCompanionLogin!.isEmpty) {
      return;
    }

    _loadingMessages = true;

    try {
      final uri = Uri.parse(
        'https://cl918558.tw1.ru/api/get_messages.php'
            '?from=${Uri.encodeComponent(widget.userName)}'
            '&to=${Uri.encodeComponent(_selectedCompanionLogin!)}',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final list = (data['messages'] as List).map<ChatMessage?>((j) {
            final sender = (j['from_user'] ?? j['user_name'])?.toString() ?? '';
            if (sender.isEmpty) return null;

            return ChatMessage(
              id: int.parse(j['id'].toString()),
              userName: sender,
              text: j['text'] as String,
              createdAt: DateTime.parse(j['created_at']),
              isMe: sender == widget.userName,
            );
          }).whereType<ChatMessage>().toList();

          setState(() {
            messages
              ..clear()
              ..addAll(list);
          });

          await Future.delayed(const Duration(milliseconds: 50));
          if (scrollController.hasClients) {
            scrollController.jumpTo(
              scrollController.position.maxScrollExtent,
            );
          }
        }
      }
    } finally {
      _loadingMessages = false;
    }
  }

  Future<void> _sendMessage(String text) async {
    if (_selectedCompanionLogin == null || _selectedCompanionLogin!.isEmpty) {
      return;
    }

    final uri = Uri.parse('https://cl918558.tw1.ru/api/send_message.php');

    try {
      final now = DateTime.now();
      setState(() {
        messages.add(
          ChatMessage(
            id: -1,
            userName: widget.userName,
            text: text,
            createdAt: now,
            isMe: true,
          ),
        );
      });

      await Future.delayed(const Duration(milliseconds: 50));
      if (scrollController.hasClients) {
        scrollController.jumpTo(
          scrollController.position.maxScrollExtent,
        );
      }

      final response = await http.post(
        uri,
        body: {
          'from': widget.userName,
          'to': _selectedCompanionLogin!,
          'text': text,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _loadMessages();
        }
      }
    } catch (_) {}
  }

  Widget _buildCompanionAvatar() {
    final url = _selectedCompanion?.avatarUrl;

    if (url != null && url.isNotEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(url),
      );
    }

    return const CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage('assets/avatars/no-avatar-user.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
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
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: GlassPanel(
                        borderRadius: BorderRadius.circular(35),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: _openUserSearch,
                              child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: .15),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.search, color: Colors.white, size: 26),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Expanded(
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                itemCount: chatUsers.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 18),
                                itemBuilder: (_, i) {
                                  final u = chatUsers[i];
                                  final ImageProvider avatar =
                                  (u.avatarUrl != null && u.avatarUrl!.isNotEmpty)
                                      ? NetworkImage(u.avatarUrl!)
                                      : const AssetImage('assets/avatars/no-avatar-user.png');
                                  return GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        _selectedCompanionLogin = u.login;
                                        _selectedCompanion = u;
                                      });
                                      await _loadMessages();
                                    },
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundImage: avatar,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 26),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        children: [
                          GlassPanel(
                            height: 60,
                            borderRadius: BorderRadius.circular(30),
                            child: Row(
                              children: [
                                const SizedBox(width: 14),
                                GestureDetector(
                                  onTap: _openMessageSearch,
                                  child: const Icon(Icons.search, size: 24),
                                ),
                                const SizedBox(width: 10),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: _isSearchActive ? 200 : 0,
                                  child: _isSearchActive
                                      ? TextField(
                                    controller: _searchController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      hintText: 'Поиск...',
                                      hintStyle: TextStyle(color: Colors.white54),
                                      border: InputBorder.none,
                                    ),
                                  )
                                      : null,
                                ),
                                if (!_isSearchActive)
                                  Expanded(
                                    child: Text(
                                      companionName,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                _buildCompanionAvatar(),
                                const SizedBox(width: 14),
                              ],
                            ),
                          ),

                          Expanded(
                            child: GlassPanel(
                              borderRadius: BorderRadius.circular(34),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      controller: scrollController,
                                      itemCount: messages.length,
                                      itemBuilder: (_, i) {
                                        final m = messages[i];
                                        final timeStr =
                                            '${m.createdAt.hour.toString().padLeft(2, '0')}:${m.createdAt.minute.toString().padLeft(2, '0')}';

                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          child: ChatBubble(
                                            text: m.text,
                                            time: timeStr,
                                            isMe: m.isMe,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  MessageInputBar(onSend: _sendMessage),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          GlassPanel(
                            height: 56,
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
                                  onTap: () {},
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
                                            begin: const Offset(1.0, 0.0),
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
                        ],
                      ),
                    ),
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