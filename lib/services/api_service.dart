import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user_data.dart';
import '../models/chat_message.dart';

class ApiService {
  static const String baseUrl = 'https://cl918558.tw1.ru/api';

  // Аутентификация
  static Future<Map<String, dynamic>> login(String login, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login.php'),
      body: {'login': login, 'password': password},
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> register(String login, String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register.php'),
      body: {'login': login, 'name': name, 'email': email, 'password': password},
    );
    return jsonDecode(response.body);
  }

  // Работа с пользователями
  static Future<List<UserData>> searchUsers(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/get_users.php?q=$query'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return (data['users'] as List).map((e) => UserData.fromJson(e)).toList();
      }
    }
    return [];
  }

  static Future<List<UserData>> getChatUsers(String login) async {
    final response = await http.get(Uri.parse('$baseUrl/get_chat_users.php?login=$login'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return (data['users'] as List).map((e) => UserData.fromJson(e)).toList();
      }
    }
    return [];
  }

  // Работа с сообщениями
  static Future<List<ChatMessage>> getMessages(String from, String to) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_messages.php?from=$from&to=$to'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return (data['messages'] as List)
            .map<ChatMessage?>((j) {
          final sender = (j['from_user'] ?? j['user_name'])?.toString() ?? '';
          if (sender.isEmpty) return null;
          return ChatMessage(
            id: int.parse(j['id'].toString()),
            userName: sender,
            text: j['text'] as String,
            createdAt: DateTime.parse(j['created_at']),
            isMe: sender == from,
            avatarUrl: j['avatar_url'] as String?,
          );
        })
            .whereType<ChatMessage>()
            .toList();
      }
    }
    return [];
  }

  static Future<Map<String, dynamic>> sendMessage(String from, String to, String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send_message.php'),
      body: {'from': from, 'to': to, 'text': text},
    );
    return jsonDecode(response.body);
  }

  // Загрузка аватара
  static Future<String?> uploadAvatar(String login, File file) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload_avatar.php'))
      ..fields['login'] = login
      ..files.add(await http.MultipartFile.fromPath('avatar', file.path));

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(body);
        if (data['success'] == true) {
          return data['avatar_url'] as String;
        }
      } catch (_) {}
    }
    return null;
  }
}