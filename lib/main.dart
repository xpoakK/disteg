import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

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
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatScreen()),
                );
              },
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



/////////////ЧАТ////////////ЧАТ/////////////////ЧАТ/////////////ЧАТ/////////////ЧАТ/////////////ЧАТ/////////////ЧАТ///////



// ==========================
//          MODELS
// ==========================

// Простая модель для сообщения
class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}

// Простая модель для пользователя
class ChatUser {
  final String name;
  final String avatarUrl;
  final bool isOnline;

  ChatUser({
    required this.name,
    required this.avatarUrl,
    this.isOnline = false,
  });
}

// ==========================
//          CHAT SCREEN
// ==========================
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // 1. Адекватные данные пользователей (Заглушки)
  // Используем i.pravatar.cc для генерации лиц
  final List<ChatUser> users = [
    ChatUser(name: "Елена", avatarUrl: "https://i.pravatar.cc/150?img=5", isOnline: true),
    ChatUser(name: "Дмитрий", avatarUrl: "https://i.pravatar.cc/150?img=11"),
    ChatUser(name: "Анна", avatarUrl: "https://i.pravatar.cc/150?img=9", isOnline: true),
    ChatUser(name: "Максим", avatarUrl: "https://i.pravatar.cc/150?img=3"),
    ChatUser(name: "Олег", avatarUrl: "https://i.pravatar.cc/150?img=13"),
    ChatUser(name: "Светлана", avatarUrl: "https://i.pravatar.cc/150?img=1"),
  ];

  // Выбранный сейчас пользователь (по умолчанию первый)
  late ChatUser currentUser;

  // Список сообщений
  final List<ChatMessage> messages = [
    ChatMessage(text: "Привет! Как дела?", isMe: false, time: DateTime.now().subtract(const Duration(minutes: 5))),
    ChatMessage(text: "Привет, все отлично! Делаю дизайн чата.", isMe: true, time: DateTime.now().subtract(const Duration(minutes: 4))),
    ChatMessage(text: "Выглядит неплохо, продолжай в том же духе 👍", isMe: false, time: DateTime.now().subtract(const Duration(minutes: 2))),
  ];

  @override
  void initState() {
    super.initState();
    currentUser = users[0];
  }

  void sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      messages.add(
        ChatMessage(
          text: _controller.text.trim(),
          isMe: true, // Отправляем от себя
          time: DateTime.now(),
        ),
      );
    });

    _controller.clear();

    // Автопрокрутка вниз
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Имитация ответа собеседника (для живости)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          messages.add(ChatMessage(
              text: "Интересно... Расскажи подробнее!",
              isMe: false,
              time: DateTime.now()
          ));
        });
        // Снова скролл вниз после ответа
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  void switchUser(ChatUser user) {
    setState(() {
      currentUser = user;
      // Очистим чат или загрузим историю для демо можно просто оставить как есть
      // или добавить приветственное сообщение от нового юзера
      messages.add(ChatMessage(
          text: "Чат с пользователем ${user.name} открыт.",
          isMe: false,
          time: DateTime.now()
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Фон градиент
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE0E0E0),
                  Color(0xFF4A4A4A),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Row(
              children: [
                // ==============================
                //     ЛЕВАЯ КОЛОНКА (КОНТАКТЫ)
                // ==============================
                Container(
                  width: 65,
                  margin: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: ListView.builder(
                    itemCount: users.length,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final isSelected = currentUser == user;

                      return GestureDetector(
                        onTap: () => switchUser(user),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          padding: const EdgeInsets.all(2), // border width
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // Подсветка выбранного
                            border: isSelected
                                ? Border.all(color: Colors.blueAccent, width: 2)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(user.avatarUrl),
                            backgroundColor: Colors.grey.shade300,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ==============================
                //      ОСНОВНОЙ БЛОК ЧАТА
                // ==============================
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // ------------------------------
                      //  ВЕРХ – АВАТАР + ИМЯ (HEADER)
                      // ------------------------------
                      Container(
                        height: 60,
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(currentUser.avatarUrl),
                                ),
                                if (currentUser.isOnline)
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentUser.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  currentUser.isOnline ? "В сети" : "Был(а) недавно",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: currentUser.isOnline ? Colors.green[700] : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.more_vert, color: Colors.grey)
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ------------------------------
                      //     СПИСОК СООБЩЕНИЙ
                      // ------------------------------
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(top: 15, bottom: 15),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final msg = messages[index];
                              return Align(
                                alignment: msg.isMe
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.65,
                                  ),
                                  decoration: BoxDecoration(
                                    color: msg.isMe
                                        ? const Color(0xFF2B2B2B) // Цвет для себя
                                        : Colors.white,           // Цвет для других
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(16),
                                      topRight: const Radius.circular(16),
                                      bottomLeft: Radius.circular(msg.isMe ? 16 : 2),
                                      bottomRight: Radius.circular(msg.isMe ? 2 : 16),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        msg.text,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: msg.isMe ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${msg.time.hour}:${msg.time.minute.toString().padLeft(2, '0')}",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: msg.isMe ? Colors.white70 : Colors.black45,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ------------------------------
                      //     ПОЛЕ ВВОДА
                      // ------------------------------
                      Container(
                        margin: const EdgeInsets.only(right: 10, bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      color: Colors.black.withOpacity(0.1),
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: TextField(
                                    controller: _controller,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Написать сообщение...",
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                    onSubmitted: (_) => sendMessage(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: sendMessage,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2B2B2B),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      color: Colors.black.withOpacity(0.3),
                                    )
                                  ],
                                ),
                                child: const Icon(
                                  Icons.arrow_upward_rounded,
                                  size: 24,
                                  color: Colors.white,
                                ),
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
        ],
      ),
    );
  }
}