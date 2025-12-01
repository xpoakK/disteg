import 'package:flutter/material.dart';

class SidebarChannels extends StatelessWidget {
  const SidebarChannels({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: const Color(0xFF2B2D31),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E1F22),
            child: const Text(
              "Личные сообщения",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),

          // Список диалогов
          Expanded(
            child: ListView(
              children: List.generate(
                10,
                    (i) => ListTile(
                  leading: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white24,
                  ),
                  title: Text(
                    "Пользователь $i",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
