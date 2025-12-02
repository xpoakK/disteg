import 'package:flutter/material.dart';
import 'dart:ui';

import '../screens/settings_screen.dart';

typedef OnUserSelected = void Function(String user);
typedef OnThemeChange = void Function(ThemeMode mode);

class SidebarUsers extends StatefulWidget {
  final double minWidth;
  final double maxWidth;
  final bool initiallyExpanded;
  final OnUserSelected onUserSelected;
  final OnThemeChange onThemeChange;
  final ThemeMode currentThemeMode;
  final String? selectedUser;

  const SidebarUsers({
    super.key,
    required this.onUserSelected,
    required this.onThemeChange,
    required this.currentThemeMode,
    this.selectedUser,
    this.minWidth = 70,
    this.maxWidth = 280,
    this.initiallyExpanded = true,
  });

  @override
  State<SidebarUsers> createState() => _SidebarUsersState();
}

class _SidebarUsersState extends State<SidebarUsers>
    with SingleTickerProviderStateMixin {
  late bool expanded;
  late AnimationController _controller;

  final List<String> users = [
    'Alice',
    'Bob',
    'Charlie',
    'Dave',
    'Eve',
    'Mallory',
    'Trent',
  ];

  @override
  void initState() {
    super.initState();
    expanded = widget.initiallyExpanded;
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    if (expanded) _controller.value = 1.0;
  }

  void toggle() {
    setState(() {
      expanded = !expanded;
      if (expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final width = lerpDouble(widget.minWidth, widget.maxWidth, _controller.value)!;

        return Material(
          elevation: 4,
          child: Container(
            width: width,
            color: theme.cardColor,
            child: Column(
              children: [
                // Header with toggle
                SizedBox(
                  height: 64,
                  child: Row(
                    children: [
                      IconButton(
                        icon: AnimatedIcon(
                          icon: AnimatedIcons.menu_arrow,
                          progress: _controller,
                        ),
                        onPressed: toggle,
                      ),
                      if (_controller.value > 0.25)
                        Expanded(
                          child: Text(
                            "Users",
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                    ],
                  ),
                ),

                // Настройки
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.white),
                  title: const Text("Настройки",
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SettingsScreen(
                          isDesktop: isDesktop,
                          onThemeChange: widget.onThemeChange,
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),

                // Список пользователей
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, i) {
                      final u = users[i];
                      final selected = widget.selectedUser == u;

                      return InkWell(
                        onTap: () => widget.onUserSelected(u),
                        child: Container(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          color: selected
                              ? theme.primaryColor.withOpacity(0.08)
                              : null,
                          child: Row(
                            children: [
                              CircleAvatar(child: Text(u[0])),
                              const SizedBox(width: 12),
                              // имя плавно показывается при expand
                              ClipRect(
                                child: SizedBox(
                                  width: (width - 120).clamp(0, 180),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Opacity(
                                      opacity: _controller.value,
                                      child: Text(
                                        u,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
