import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';
import '../models/user_data.dart';
import '../utils/constants.dart';

class ApiService {
  static Future<List<ChatMessage>> getMessages(
      String from, String to) async {
    final uri = Uri.parse(
      '$apiBaseUrl/get_messages.php'
          '?from=${Uri.encodeComponent(from)}'
          '&to=${Uri.encodeComponent(to)}',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return (data['messages'] as List)
            .map<ChatMessage?>((j) {
          final sender =
              (j['from_user'] ?? j['user_name'])?.toString() ?? '';
          if (sender.isEmpty) return null;
          return ChatMessage(
            id: int.parse(j['id'].toString()),
            userName: sender,
            text: j['text'] as String,
            createdAt: DateTime.parse(j['created_at']),
            isMe: sender == from,
          );
        })
            .whereType<ChatMessage>()
            .toList();
      }
    }
    return [];
  }

  static Future<bool> sendMessage(
      String from, String to, String text) async {
    final uri = Uri.parse('$apiBaseUrl/send_message.php');

    final response = await http.post(
      uri,
      body: {
        'from': from,
        'to': to,
        'text': text,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['success'] == true;
    }
    return false;
  }

  static Future<List<UserData>> searchUsers(String query) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.parse(
      '$apiBaseUrl/get_users.php?q=$query',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return (data['users'] as List)
            .map((e) => UserData.fromJson(e))
            .toList();
      }
    }

    return [];
  }

  static Future<List<UserData>> getChatUsers(String login) async {
    final uri = Uri.parse(
      "$apiBaseUrl/get_chat_users.php?login=$login",
    );

    try {
      final r = await http.get(uri);

      if (r.statusCode == 200) {
        final data = jsonDecode(r.body);
        if (data["success"] == true) {
          return (data["users"] as List)
              .map((e) => UserData.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('get_chat_users error: $e');
    }

    return [];
  }

  static Future<bool> hasMessagesWith(String from, String to) async {
    final uri = Uri.parse(
      '$apiBaseUrl/get_messages.php'
          '?from=${Uri.encodeComponent(from)}'
          '&to=${Uri.encodeComponent(to)}',
    );

    try {
      final r = await http.get(uri);
      if (r.statusCode != 200) return false;

      final data = jsonDecode(r.body);
      if (data['success'] != true) return false;

      final msgs = data['messages'] as List;
      return msgs.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> clearChat(String from, String to) async {
    final uri = Uri.parse('$apiBaseUrl/clear_chat.php');

    try {
      await http.post(uri, body: {
        'from': from,
        'to': to,
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> blockUser(String blocker, String blocked) async {
    final uri = Uri.parse('$apiBaseUrl/block_user.php');

    try {
      await http.post(uri, body: {
        'blocker': blocker,
        'blocked': blocked,
      });
      return true;
    } catch (_) {
      return false;
    }
  }
}