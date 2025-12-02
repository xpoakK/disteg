import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message.dart';

class MessageCache {
  static const String key = "cached_messages";

  static Future<void> saveMessages(List<Message> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = messages.map((m) => m.toJson()).toList();
    prefs.setString(key, jsonEncode(jsonData));
  }

  static Future<List<Message>> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);

    if (raw == null) return [];

    final List data = jsonDecode(raw);
    return data.map((e) => Message.fromJson(e)).toList();
  }
}
