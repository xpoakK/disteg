import 'dart:convert';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';








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
          : const DisTegScreen(),
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
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final h = constraints.maxHeight;

              return Stack(
                children: [
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
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Новый мессенджер,\n'
                                'собравший в себе все самые\n'
                                'лучшие функции',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.3,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: h * 0.14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GlassButton(
                            text: 'Войти',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          GlassButton(
                            text: 'Зарегистрироваться',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegistrationScreen(),
                                ),
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
class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double width;
  final double height;
  final double fontSize;
  final double blur;
  final double borderOpacity;

  const GlassButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width = 300,
    this.height = 50,
    this.fontSize = 23,
    this.blur = 12,
    this.borderOpacity = 0.8,
  });

  factory GlassButton.login({
    required String text,
    required VoidCallback onTap,
  }) {
    return GlassButton(
      text: text,
      onTap: onTap,
      width: 260,
      height: 46,
      fontSize: 22,
      blur: 10,
      borderOpacity: 0.7,
    );
  }

  factory GlassButton.register({
    required String text,
    required VoidCallback onTap,
  }) {
    return GlassButton(
      text: text,
      onTap: onTap,
      width: 300,
      height: 50,
      fontSize: 24,
      blur: 14,
      borderOpacity: 0.9,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(33),
              color: Colors.white.withValues(alpha: .08),
              border: Border.all(
                color: Colors.white.withValues(alpha: borderOpacity),
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
              style: TextStyle(
                fontSize: fontSize,
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
      // логин как уникальный userName
      final login = _loginController.text.trim();
      final userName = login.isEmpty ? 'user' : login;

      // сохраняем в SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('logged_in', true);
      await prefs.setString('user_name', userName);

      // переходим в чат
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
                    _InputField(
                      label: 'Логин/Эл. почта',
                      controller: _loginController,
                    ),
                    const SizedBox(height: 20),
                    _InputField(
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


// ==========================
//     REGISTRATION SCREEN
// ==========================
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

    final uri = Uri.parse('https://cl918558.tw1.ru/api/register.php');

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
  // используем login как идентификатор в системе чата
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
        SnackBar(content: Text(data['message'] ?? 'Ошибка регистрации')),
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
                    _InputField(
                      label: 'Логин',
                      controller: _loginController,
                    ),
                    const SizedBox(height: 20),
                    _InputField(
                      label: 'Имя',
                      controller: _nameController,
                    ),
                    const SizedBox(height: 20),
                    _InputField(
                      label: 'Эл. почта',
                      controller: _emailController,
                    ),
                    const SizedBox(height: 20),
                    _InputField(
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

class _InputField extends StatefulWidget {
  final String label;
  final bool obscure;
  final TextEditingController controller;

  const _InputField({
    required this.label,
    required this.controller,
    this.obscure = false,
  });

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() {
      setState(() {}); // обновляет UI при фокусе/потере фокуса
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: widget.controller,
      obscureText: widget.obscure,
      decoration: InputDecoration(
        hintText: focusNode.hasFocus ? '' : widget.label, // исчезает при фокусе
        hintStyle: TextStyle(color: Colors.grey.shade600),
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

class ChatMessage {
  final int id;
  final String userName;
  final String text;
  final DateTime createdAt;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.userName,
    required this.text,
    required this.createdAt,
    required this.isMe,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, String currentUserName) {
    return ChatMessage(
      id: int.parse(json['id'].toString()),
      userName: json['user_name'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['created_at']),
      isMe: (json['user_name'] as String) == currentUserName,
    );
  }
}


// ==========================
//        CHAT SCREEN
// ==========================
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

  bool _loadingMessages = false;
  bool _isSearchActive = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _pollTimer;

  String? _selectedCompanionLogin;


  String get companionName {
  // если пользователь выбран из поиска — показываем его
  if (_selectedCompanionLogin != null && _selectedCompanionLogin!.isNotEmpty) {
    return _selectedCompanionLogin!;
  }

  // иначе берём из последних сообщений не от меня
  final others = messages.where((m) => !m.isMe);
  if (others.isNotEmpty) {
    return others.last.userName;
  }

  return 'Чат';
}


    // поиск пользователей по логину/имени через API
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


  @override
  void initState() {
    super.initState();
    _loadMessages();
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

  // если собеседник ещё не выбран — нечего грузить
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
  // пробуем взять from_user, если нет — user_name
  final sender = (j['from_user'] ?? j['user_name'])?.toString() ?? '';

  if (sender.isEmpty) {
    // если вообще нет отправителя — пропускаем такое сообщение
    return null;
  }

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
    // никто не выбран — можно показать SnackBar
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
        _loadMessages(); // перезагружаем уже из БД
      }
    }
  } catch (_) {}
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Stack(
          children: [
            // фон
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
                    // ЛЕВАЯ ПАНЕЛЬ
                    SizedBox(
                      width: 70,
                      child: _GlassPanel(
                        borderRadius: BorderRadius.circular(35),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            Expanded(
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12),
                                itemCount: 7,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 18),
                                itemBuilder: (_, index) {
                                  return CircleAvatar(
                                    radius: 22,
                                    backgroundImage: AssetImage(
                                      'assets/avatars/a$index.jpg',
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.white,
                              size: 26,
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // ПРАВАЯ ЧАСТЬ
                    Expanded(
                      child: Column(
                        children: [
                          // ВЕРХНЯЯ ПАНЕЛЬ
                          _GlassPanel(
                            height: 60,
                            borderRadius: BorderRadius.circular(30),
                            child: Row(
                              children: [
                                const SizedBox(width: 14),
                                GestureDetector(
  onTap: () async {
    final selectedUser = await showSearch<String?>(
      context: context,
      delegate: ChatSearchDelegate(searchUsers),
    );

    if (selectedUser != null) {
      setState(() {
        _selectedCompanionLogin = selectedUser; // ← сохраняем выбранного
      });

      debugPrint('Выбран пользователь: $selectedUser');
      // здесь позже можно подгружать другой чат по selectedUser
      await _loadMessages();
    }
  },
  child: const Icon(Icons.search, size: 24),
),



                                const SizedBox(width: 10),
                                AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 300),
                                  width: _isSearchActive ? 200 : 0,
                                  child: _isSearchActive
                                      ? TextField(
                                          controller: _searchController,
                                          style: const TextStyle(
                                              color: Colors.white),
                                          decoration:
                                              const InputDecoration(
                                            hintText: 'Поиск...',
                                            hintStyle: TextStyle(
                                                color: Colors.white54),
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
      ),
    ),
  ),

                                const CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(
                                      'assets/avatars/current.jpg'),
                                ),
                                const SizedBox(width: 14),
                              ],
                            ),
                          ),

                          // ЧАТ
                          Expanded(
                            child: _GlassPanel(
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
                                          padding:
                                              const EdgeInsets.only(
                                                  bottom: 12),
                                          child: _ChatBubble(
                                            text: m.text,
                                            time: timeStr,
                                            isMe: m.isMe,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _MessageInputBar(
                                    onSend: _sendMessage,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // НИЖНЕЕ МЕНЮ
                          _GlassPanel(
                            height: 56,
                            borderRadius: BorderRadius.circular(28),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                // SETTINGS PNG
                                GestureDetector(
                                  onTap: () {},
                                  child: Image.asset(
                                    'assets/icons/settings.png',
                                    width: 28,
                                    height: 28,
                                  ),
                                ),

                                // CHAT PNG
                                GestureDetector(
                                  onTap: () {},
                                  child: Image.asset(
                                    'assets/icons/chat.png',
                                    width: 28,
                                    height: 28,
                                  ),
                                ),

                                // PROFILE PNG — переход в профиль
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(
                                                milliseconds: 250),
                                        pageBuilder: (_, __, ___) =>
                                            ProfileScreen(
                                          userName: widget.userName,
                                        ),
                                        transitionsBuilder:
                                            (_, animation, __, child) {
                                          final offsetAnimation =
                                              Tween<Offset>(
                                            begin:
                                                const Offset(1.0, 0.0),
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



/// Универсальная стеклянная панель
class _GlassPanel extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BorderRadius borderRadius;
  final double blur;
  final double backgroundOpacity;
  final double borderOpacity;
  final double borderWidth;
  final Color borderColor;

  const _GlassPanel({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.padding,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.blur = 14,
    this.backgroundOpacity = 0.25,
    this.borderOpacity = 0.75,
    this.borderWidth = 1,
    this.borderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          height: height,
          width: width,
          padding: padding ?? const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: Colors.white.withValues(alpha: backgroundOpacity),
            border: Border.all(
              color: borderColor.withValues(alpha: borderOpacity),
              width: borderWidth,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isMe;

  const _ChatBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;

    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: isMe ? const Radius.circular(18) : const Radius.circular(4),
      bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(18),
    );

    return Align(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF707070),
              borderRadius: borderRadius,
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            time,
            style: TextStyle(
              fontSize: 10,
              color: Colors.black.withValues(alpha: .6),
            ),
          ),
        ],
      ),
    );
  }
}


class _MessageInputBar extends StatefulWidget {
  final Function(String) onSend;

  const _MessageInputBar({super.key, required this.onSend});

  @override
  State<_MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<_MessageInputBar> {
  final TextEditingController _controller = TextEditingController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onSend(text); // передаём сообщение наверх

    _controller.clear(); // очищаем поле после отправки
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _send(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                hintText: 'Сообщение...',
                hintStyle: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: _send,
            child: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 6),
              decoration: const BoxDecoration(
                color: Color(0xFF6F6F6F),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserData {
  final String login;
  final String name;

  UserData({required this.login, required this.name});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      login: json['login'],
      name: json['name'],
    );
  }
}


// ==========================
//    ПОИСК ПО USERNAME
// ==========================
class ChatSearchDelegate extends SearchDelegate<String?> {
  final Future<List<UserData>> Function(String) onSearch;

  ChatSearchDelegate(this.onSearch);

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back),
      );

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<UserData>>(
      future: onSearch(query),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());

        final users = snap.data!;
        if (users.isEmpty) return const Center(child: Text("Пользователи не найдены"));

        return ListView(
          children: users.map((u) {
            return ListTile(
              title: Text(u.login),
              subtitle: Text(u.name),
              onTap: () => close(context, u.login),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}




// ==========================
//        PROFILE SCREEN
// ==========================
class ProfileScreen extends StatelessWidget {
  final String userName;

  const ProfileScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        // свайп вправо -> чат
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 0) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (_, __, ___) => ChatScreen(userName: userName),
                transitionsBuilder: (_, animation, __, child) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(-1.0, 0.0), // ← резкий выезд СЛЕВА
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
            // Фон
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/chat_ground.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Контент
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Аватар
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const CircleAvatar(
                          radius: 70,
                          backgroundImage:
                          AssetImage('assets/avatars/current.jpg'),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
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
                                  color:
                                  Colors.black.withValues(alpha: .25),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add_a_photo_outlined,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Имя
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Кнопки действий
                  _ProfileActionButton(
                    text: 'Редактировать профиль',
                    onTap: () {},
                  ),
                  const SizedBox(height: 18),

                  _ProfileActionButton(
                    text: 'Избранное',
                    onTap: () {},
                  ),
                  const SizedBox(height: 18),

                  _ProfileActionButton(
                    text: 'Описание',
                    onTap: () {},
                  ),
                  const SizedBox(height: 18),

                  _ProfileActionButton(
                    text: 'Выйти из аккаунта',
                    textColor: Colors.red,
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear(); // или remove('logged_in') / remove('user_name')

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const DisTegScreen()),
                            (route) => false,
                      );
                    },
                  ),

                  const Spacer(),

                  // Нижнее меню
                  Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: _GlassPanel(
                        height: 56,
                        width: 250,
                        borderRadius: BorderRadius.circular(28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // SETTINGS PNG
                            GestureDetector(
                              onTap: () {
                                // экран настроек (пока пусто)
                              },
                              child: Image.asset(
                                'assets/icons/settings.png', // свой путь
                                width: 28,
                                height: 28,
                              ),
                            ),

                            // CHAT PNG + анимация в чат
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: const Duration(milliseconds: 200),
                                    pageBuilder: (_, __, ___) => ChatScreen(userName: userName),
                                    transitionsBuilder: (_, animation, __, child) {
                                      final offsetAnimation = Tween<Offset>(
                                        begin: const Offset(-1.0, 0.0), // выезд слева
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
                                'assets/icons/chat.png', // свой путь
                                width: 28,
                                height: 28,
                              ),
                            ),

                            // PROFILE PNG (мы уже на профиле)
                            GestureDetector(
                              onTap: () {
                                // ничего, уже тут
                              },
                              child: Image.asset(
                                'assets/icons/profile.png', // свой путь
                                width: 28,
                                height: 28,
                              ),
                            ),
                          ],
                        ),
                      )
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

class _ProfileActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color textColor;

  const _ProfileActionButton({
    required this.text,
    required this.onTap,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 280,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white.withValues(alpha: .25),
              border: Border.all(
                color: Colors.white.withValues(alpha: .8),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                  color: Colors.black.withValues(alpha: .15),
                ),
              ],
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


