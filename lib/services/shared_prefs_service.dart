import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static Future<bool> saveUserData({
    required bool isLoggedIn,
    required String userName,
    required int userId,
    String? avatarUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('logged_in', isLoggedIn);
    await prefs.setString('user_name', userName);
    await prefs.setInt('user_id', userId);

    if (avatarUrl != null) {
      await prefs.setString('avatar_url', avatarUrl);
    }

    return true;
  }

  static Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'isLoggedIn': prefs.getBool('logged_in') ?? false,
      'userName': prefs.getString('user_name') ?? '',
      'userId': prefs.getInt('user_id') ?? 0,
      'avatarUrl': prefs.getString('avatar_url'),
    };
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> saveAvatarUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatar_url', url);
  }

  static Future<String?> getAvatarUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('avatar_url');
  }
}