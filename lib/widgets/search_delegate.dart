import 'package:flutter/material.dart';
import '../models/user_data.dart';

class ChatSearchDelegate extends SearchDelegate<String?> {
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
              subtitle: Text(u.name),
              onTap: () => close(context, u.login),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}