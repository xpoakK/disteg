import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

Future<void> registerFcmToken(String login) async {
  final messaging = FirebaseMessaging.instance;

  // Запрос разрешения на уведомления (Android 13+, iOS)
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  final token = await messaging.getToken();
  print('FCM token = $token');

  if (token == null) return;

  final url = Uri.parse('$apiBaseUrl/save_fcm_token.php');

  await http.post(
    url,
    body: {
      'login': login,
      'fcm_token': token,
    },
  );
}