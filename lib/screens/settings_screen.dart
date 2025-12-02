import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDesktop;
  final Function(ThemeMode) onThemeChange;

  const SettingsScreen({
    super.key,
    required this.isDesktop,
    required this.onThemeChange,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Основные настройки
            const SizedBox(height: 16),
            const Text(
              "Здесь будут настройки приложения",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),

            // Кнопки смены темы
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => onThemeChange(ThemeMode.light),
                  icon: const Icon(Icons.wb_sunny_outlined),
                  label: const Text("Светлая"),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => onThemeChange(ThemeMode.dark),
                  icon: const Icon(Icons.nightlight_round),
                  label: const Text("Тёмная"),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
