import 'package:flutter/material.dart';
import 'menu_item.dart';

class MenuPanel extends StatelessWidget {
  final VoidCallback onSearch;
  final VoidCallback onClear;
  final VoidCallback onBlock;

  const MenuPanel({
    super.key,
    required this.onSearch,
    required this.onClear,
    required this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 260,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Colors.white.withValues(alpha: .25),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MenuItem(text: "Поиск", onTap: onSearch),
            MenuItem(text: "Очистить чат", onTap: onClear),
            MenuItem(text: "Заблокировать", onTap: onBlock, isDanger: true),
          ],
        ),
      ),
    );
  }
}