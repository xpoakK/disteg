import 'package:flutter/material.dart';
import '../models/user_data.dart';
import '../models/chat_message.dart';

class ChatSearchDelegate extends SearchDelegate<UserData?> {
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
              subtitle: Text(u.name ?? ''),
              onTap: () => close(context, u),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}

class MessageSearchDelegate extends SearchDelegate<ChatMessage?> {
  final List<ChatMessage> messages;

  MessageSearchDelegate(this.messages);

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
    final results = messages
        .where((m) => m.text.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return const Center(child: Text("Сообщения не найдены"));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final msg = results[index];
        return ListTile(
          title: Text(msg.userName),
          subtitle: Text(msg.text),
          trailing: Text(
            "${msg.createdAt.hour}:${msg.createdAt.minute.toString().padLeft(2, '0')}",
            style: const TextStyle(color: Colors.grey),
          ),
          onTap: () => close(context, msg),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}
