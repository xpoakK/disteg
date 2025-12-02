class MessageModel {
  final String id;
  final String author;
  final String text;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.author,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "author": author,
    "text": text,
    "createdAt": createdAt.toIso8601String(),
  };

  factory MessageModel.fromMap(Map map) => MessageModel(
    id: map["id"] as String,
    author: map["author"] as String,
    text: map["text"] as String,
    createdAt: DateTime.parse(map["createdAt"] as String),
  );
}
