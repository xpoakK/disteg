import 'package:flutter/material.dart';

class ChatWindow extends StatefulWidget {
  final String? username;

  const ChatWindow({super.key, required this.username});

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final Map<String, List<Map<String, dynamic>>> messagesPerUser = {};
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  void sendMessage() {
    final text = controller.text.trim();
    if (text.isEmpty || widget.username == null) return;

    final msg = {
      "text": text,
      "time": TimeOfDay.now(),
      "fromMe": true,
    };

    setState(() {
      messagesPerUser.putIfAbsent(widget.username!, () => []).add(msg);
    });

    controller.clear();
    // Перерисовать чтобы кнопка отправки стала неактивной
    setState(() {});

    // Прокрутка вниз
    Future.delayed(const Duration(milliseconds: 50), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.username;
    final messages = user != null ? messagesPerUser[user] ?? [] : [];

    return Column(
      children: [
        // Верхний бар — аватар выбранного пользователя
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          decoration: const BoxDecoration(
            color: Color(0xFF2B2B2B),
            border: Border(
              bottom: BorderSide(color: Color(0xFF3A3A3A)),
            ),
          ),
          child: Row(
            children: [
              if (user != null)
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade700,
                  child: Text(
                    user[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(child: Container()),
            ],
          ),
        ),

        // Список сообщений
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, i) {
              final msg = messages[i];
              return Align(
                alignment: msg["fromMe"] ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: msg["fromMe"] ? Colors.blueGrey : const Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(msg["text"], style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(
                        "${msg["time"].hour}:${msg["time"].minute.toString().padLeft(2, "0")}",
                        style: TextStyle(color: Colors.grey[400], fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Поле ввода
        Container(
          padding: const EdgeInsets.all(12),
          color: const Color(0xFF2B2B2B),
          child: Row(
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 120),
                  child: TextField(
                    controller: controller,
                    maxLines: null,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Написать сообщение...",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: const Color(0xFF3A3A3A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    ),
                    onChanged: (text) {
                      setState(() {}); // чтобы кнопка отправки реагировала
                    },
                    onSubmitted: (_) => sendMessage(), // Enter = отправка
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: controller.text.trim().isEmpty ? Colors.grey : Colors.white,
                ),
                onPressed: controller.text.trim().isEmpty ? null : sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
