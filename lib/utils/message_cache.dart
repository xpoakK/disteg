import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/message.dart';

class MessageCache {
  static const _boxName = 'messages_box';

  /// Инициализация — вызвать один раз в main()
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  static Future<List<MessageModel>> loadMessages({String roomId = 'global'}) async {
    final box = Hive.box(_boxName);
    final raw = box.get(roomId);
    if (raw == null) return [];
    final List list = jsonDecode(raw);
    return list.map((e) => MessageModel.fromMap(e)).toList();
  }

  static Future<void> saveMessages(List<MessageModel> messages, {String roomId = 'global'}) async {
    final box = Hive.box(_boxName);
    final payload = messages.map((m) => m.toMap()).toList();
    await box.put(roomId, jsonEncode(payload));
  }
}
