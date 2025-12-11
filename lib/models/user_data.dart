class UserData {
  final String login;
  final String? name;
  final String? avatarUrl;

  UserData({
    required this.login,
    this.name,
    this.avatarUrl,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      login: json['login'] as String,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}