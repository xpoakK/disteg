class UserData {
  final String login;
  final String name;
  final String? avatarUrl;

  UserData({required this.login, required this.name, this.avatarUrl});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      login: json['login'],
      name: json['name'],
      avatarUrl: json['avatar_url'],
    );
  }
}