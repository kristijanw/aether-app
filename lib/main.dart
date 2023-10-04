import 'dart:developer';

import 'package:app/firebase_options.dart';
import 'package:app/screens/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'services/local_notif.dart';

FlutterLocalNotificationsPlugin locNotf = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotification.init(locNotf);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  requestPermission();
  listenMessage();

  FirebaseMessaging.instance.getToken().then((value) {
    log("$value");
  });

  initializeDateFormatting().then((_) => runApp(const App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [
        Locale('hr', 'HR'),
      ],
      debugShowCheckedModeBanner: false,
      home: Loading(),
    );
  }
}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: false,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // ignore: avoid_print
  print('User granted permission: ${settings.authorizationStatus}');
}

void listenMessage() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      // ignore: avoid_print
      print('Message also contained a notification: ${message.notification}');

      LocalNotification.showNotification(
        title: message.notification!.title ?? 'Title',
        body: message.notification!.body ?? 'Body',
        flutterLocalNotificationsPlugin: locNotf,
      );
    }

    if (message.notification != null) {
      // ignore: avoid_print
      print('Message also contained a notification: ${message.notification}');
    }
  });
}
