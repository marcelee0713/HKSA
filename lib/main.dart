import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hksa/constant/colors.dart';
import 'package:hksa/firebase_options.dart';
import 'package:hksa/pages/adminPages/home.dart';
import 'package:hksa/pages/professorPages/home.dart';
import 'package:hksa/widgets/dialogs/dialog_success.dart';
import 'pages/login.dart';
import 'pages/scholarPages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

bool? userLoggedIn;
String? userType;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();

  var logInBox = await Hive.openBox("myLoginBox");
  var registrationBox = await Hive.openBox("myRegistrationBox");
  userLoggedIn = await logInBox.get("isLoggedIn");
  userType = await logInBox.get("userType");

  userLoggedIn ??= false;

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
  print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null && userLoggedIn!) {
      showNotification(message.notification!.title.toString(),
          message.notification!.body.toString());
      print(
          'Message also contained a notification: ${message.notification?.body.toString()}');
      print(
          'Message also contained a notification: ${message.notification?.title.toString()}');
    } else {
      print(
          'Message also contained a notification: ${message.notification?.body.toString()}');
      print(
          'Message also contained a notification: ${message.notification?.title.toString()}');
    }
  });
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_notification');
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  runApp(
    MaterialApp(
      title: "HKSA",
      home: const MyApp(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: ColorPalette.primary, secondary: ColorPalette.secondary),
        scaffoldBackgroundColor: ColorPalette.secondary,
      ),
    ),
  );
}

void showNotification(String title, String body) async {
  await _demoNotification(title, body);
}

Future<void> _demoNotification(String title, String body) async {
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel_ID', 'channel name',
      channelDescription: 'channel description',
      colorized: true,
      color: ColorPalette.secondary,
      icon: '@mipmap/ic_notification',
      importance: Importance.max,
      playSound: true,
      showProgress: true,
      priority: Priority.high,
      ticker: 'test ticker');

  var iOSChannelSpecifics = const DarwinNotificationDetails();

  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
  await flutterLocalNotificationsPlugin
      .show(0, title, body, platformChannelSpecifics, payload: 'test');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (userLoggedIn!) {
      if (userType == "scholar") {
        return const HomeScholar();
      }
      if (userType == "professor") {
        return const HomeProfessor();
      }
      if (userType == "head") {
        return const HomeAdmin();
      }
    }
    return const Login();
  }
}
