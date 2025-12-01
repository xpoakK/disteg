import 'package:flutter/material.dart';

class SidebarContacts extends StatelessWidget {
  const SidebarContacts({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      color: const Color(0xFF1E1F22),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // Кнопка "Дом"
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.home, color: Colors.white),
          ),

          const SizedBox(height: 15),

          // Контакты/чаты (временно статические)
          Expanded(
            child: ListView(
              children: List.generate(
                6,
                    (i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: CircleAvatar(
                    radius: 23,
                    backgroundColor: Colors.grey.shade700,
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
