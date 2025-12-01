import 'package:flutter/material.dart';
import '../widgets/sidebar_users.dart';
import '../widgets/chat_window.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SidebarUsers(
              onSelect: (user) => setState(() => selectedUser = user),
              selectedUser: selectedUser,
            ),
            Expanded(
              child: ChatWindow(username: selectedUser),
            ),
          ],
        ),
      ),
    );
  }
}
