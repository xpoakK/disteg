import 'package:flutter/material.dart';
import '../widgets/sidebar_users.dart';
import '../widgets/chat_window.dart';

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChange;
  final ThemeMode currentThemeMode;

  const HomeScreen({
    super.key,
    required this.onThemeChange,
    required this.currentThemeMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedUser;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isDesktop = constraints.maxWidth >= 900;

      return Scaffold(
        // Drawer для мобильных
        drawer: isDesktop
            ? null
            : Drawer(
          child: SidebarUsers(
            onUserSelected: (u) {
              setState(() {
                selectedUser = u;
              });
              Navigator.of(context).maybePop();
            },
            selectedUser: selectedUser,
            initiallyExpanded: true,
            minWidth: 70,
            maxWidth: 260,
            onThemeChange: widget.onThemeChange,
            currentThemeMode: widget.currentThemeMode,
          ),
        ),
        body: Row(
          children: [
            // Desktop: показываем Sidebar
            if (isDesktop)
              SidebarUsers(
                onUserSelected: (u) {
                  setState(() => selectedUser = u);
                },
                selectedUser: selectedUser,
                minWidth: 80,
                maxWidth: 260,
                initiallyExpanded: true,
                onThemeChange: widget.onThemeChange,
                currentThemeMode: widget.currentThemeMode,
              ),
            // Основная область чата
            Expanded(
              child: Column(
                children: [
                  // Можно сюда добавить верхний AppBar или кастомный контейнер
                  Expanded(
                    child: ChatWindow(
                      username: selectedUser,
                      isMobile: !isDesktop,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
