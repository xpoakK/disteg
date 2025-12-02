class Message {
  final String username;
  final String text;

  Message({required this.username, required this.text});

  Map<String, dynamic> toJson() => {
    "username": username,
    "text": text,
  };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    username: json["username"],
    text: json["text"],
  );
}
