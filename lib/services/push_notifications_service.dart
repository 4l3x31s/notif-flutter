import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//D1:E1:84:1C:2D:C2:59:93:FD:66:F4:63:09:0D:7B:83:6D:E1:FA:7E

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  
  static String? token;

  static StreamController<String> _messageStream = new StreamController<String>.broadcast();
  static Stream<String> get messagesStram => _messageStream.stream;

  

  static Future _backgroundHandler(RemoteMessage message) async {
    //print('onBackground Handler: ${message.messageId}');
    print(message.data);
    //_messageStream.add(message.notification?.title ?? 'No title');
    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    //print('onMessage Handler: ${message.messageId}');
    print(message.data);
    //_messageStream.add(message.notification?.title ?? 'No title');
    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    //print('onMessageOpenApp Handler: ${message.messageId}');
    print(message.data);
    _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future initializeApp() async {
    //Push Notifications
    await Firebase.initializeApp();
    messaging.setAutoInitEnabled(true);
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    
    print('User granted permission: ${settings.authorizationStatus}');
    
    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');

    //Handlers

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    //Local Notifications
  }
  static closeStream(){
    _messageStream.close();
  }
}