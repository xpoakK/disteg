class ChatMessage {
  final int id;
  final String userName;
  final String text;
  final DateTime createdAt;
  final bool isMe;
  final String? avatarUrl;

  ChatMessage({
    required this.id,
    required this.userName,
    required this.text,
    required this.createdAt,
    required this.isMe,
    this.avatarUrl,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, String currentUserName) {
    return ChatMessage(
      id: int.parse(json['id'].toString()),
      userName: json['user_name'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['created_at']),
      isMe: (json['user_name'] as String) == currentUserName,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}