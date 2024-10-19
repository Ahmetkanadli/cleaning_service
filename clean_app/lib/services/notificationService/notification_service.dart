import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<String?> get _apiKey async => await _secureStorage.read(key: 'api_key');

  // API anahtarını kaydetmek için bir metod
  Future<void> saveApiKey(String apiKey) async {
    await _secureStorage.write(key: 'api_key', value: apiKey);
  }


  Future<void> initialize() async {
    // Firebase Cloud Messaging'i yapılandırma
    await _firebaseMessaging.requestPermission();
    
    // FCM token'ını al ve sunucuya kaydet
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");
    await _sendTokenToServer(token);

    // Local bildirimleri yapılandır
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/bildirim');
    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Arka planda çalışırken gelen bildirimleri işle
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Ön planda çalışırken gelen bildirimleri işle
    FirebaseMessaging.onMessage.listen(_handleMessage);

    // Bildirime tıklandığında yapılacak işlemleri ayarla
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  Future<void> _sendTokenToServer(String? token) async {
    // TODO: Token'ı PHP sunucunuza gönderin
    // Örnek: bir HTTP POST isteği kullanarak token'ı sunucuya gönderebilirsiniz
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    print("Ön planda bildirim alındı: ${message.notification?.title}");
    await _showLocalNotification(message);
  }

  Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    print("Bildirim tıklandı: ${message.notification?.title}");
    // TODO: Bildirimin içeriğine göre uygun sayfaya yönlendir
  }

 Future<void> _showLocalNotification(RemoteMessage message) async {
  final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'pestvet_temizlik',
    'Pestvet Temizlik',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@drawable/bildirim', // Bu satırı ekleyin
  );
  final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  
  await _flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title ?? '',
    message.notification?.body ?? '',
    platformChannelSpecifics,
    );
  }

  Future<void> sendNotification({
    required String to,
    required String title,
    required String body,
    Map<String, dynamic>? data,
    required String fcmToken,
  }) async {
    final url = Uri.parse('https://pestvet.saboproje.com/bildirim.php');

    
    String? apiKey = await _apiKey;

    if (apiKey == null) {
      print('API anahtarı bulunamadı');
      return;
    }


    final payload = {
    'to': to,
    'title': title,
    'body': body,
    'data': data,
    'fcm_token': fcmToken,
  };


  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-API-Key': apiKey,
      },
      body: json.encode(payload),
    );


      if (response.statusCode == 200) {
        print('Bildirim başarıyla gönderildi');
      } else {
        print('Bildirim gönderme hatası: ${response.body}');
      }
    } catch (e) {
      print('Bildirim gönderme hatası: $e');
    }
  }


}

// Bu fonksiyon main.dart dosyasının dışında tanımlanmalıdır
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Arka planda bildirim alındı: ${message.notification?.title}");
  // Arka planda bildirim işleme mantığınızı buraya ekleyin
}

 