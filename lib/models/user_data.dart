class UserData {
  final String login;
  final String name;

  UserData({required this.login, required this.name});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      login: json['login'],
      name: json['name'],
    );
  }
}