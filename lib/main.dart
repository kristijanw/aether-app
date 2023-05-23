import 'dart:io';

import 'package:app/constant.dart';
import 'package:app/firebase_options.dart';
import 'package:app/screens/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'dbaether', // id
  'dbaether', // title
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // ignore: avoid_print
  print("Handling a background message: ${message.messageId}");
}

Future<void> approvNotification() async {
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

  // ignore: avoid_print
  print('User granted permission: ${settings.authorizationStatus}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (Platform.isIOS) {
    approvNotification();
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // ignore: avoid_print
    print('Got a message whilst in the foreground!');
    // ignore: avoid_print
    print('Message data: ${message.data}');
    // ignore: avoid_print
    print('Message title: ${message.notification!.title}');
    // ignore: avoid_print
    print('Message body: ${message.notification!.body}');

    if (message.notification != null) {
      // ignore: avoid_print
      print('Message also contained a notification: ${message.notification}');

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification!.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              color: primaryColor,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    }
  });

  initializeDateFormatting().then((_) => runApp(const App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Loading(),
    );
  }
}
