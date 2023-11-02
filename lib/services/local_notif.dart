import 'dart:developer';

import 'package:app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer' as developer;

FlutterLocalNotificationsPlugin _localNotifPlugin =
    FlutterLocalNotificationsPlugin();

class FCMNotification {
  static Future<void> init() async {
    var andInit = const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings initSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );

    var initSettings = InitializationSettings(
      android: andInit,
      iOS: initSettingsDarwin,
    );

    await _localNotifPlugin.initialize(initSettings);

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    //await localNotifPlugin.initialize(initSettings);

    requestPermission();
    getToken();

    FirebaseMessaging.onBackgroundMessage((message) async {
      log(message.toString());
    });
    FirebaseMessaging.onMessage.listen((message) async {
      log(message.toString());
    });

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      log(initialMessage.toString());
    }

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      log(message.toString());
    });

    listenMessage();
  }

  static requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    developer.log('User granted permission: ${settings.authorizationStatus}');
  }

  static Future<String> getToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    developer.log('Moj fcm token: $fcmToken');
    return fcmToken.toString();
  }

  static listenMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("$message");

      if (message.notification != null) {
        developer.log(
          'Message also contained a notification: ${message.notification}',
        );

        RemoteNotification? notification = message.notification;
        showNotification(
          title: notification!.title ?? '',
          body: notification.body ?? '',
          flutterLocalNotificationsPlugin: _localNotifPlugin,
        );
      }

      if (message.notification != null) {
        developer.log(
          'Message also contained a notification: ${message.notification}',
        );
      }
    });
  }

  static Future showNotification({
    var id = 0,
    required String title,
    required String body,
    var payload,
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'aether_notification',
      'chanel_name',
      playSound: true,
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails darwinNot = DarwinNotificationDetails();

    var not = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNot,
    );

    await flutterLocalNotificationsPlugin.show(0, title, body, not);
  }
}
