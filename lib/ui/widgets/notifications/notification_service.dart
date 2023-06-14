import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/home_screen.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/library_pages/book_page.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/library_pages/book_read_screen.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/main_menu_pages/audio_library/audio_librar_data_show.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/main_menu_pages/italian_lesson/italian_data_show.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(' --- background message received ---');
  print(message.notification!.title);
  print(message.notification!.body);
}

class NotificationService {
  factory NotificationService() {
    return _notificationService;
  }
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  NotificationService._internal();

  static const channelId = '123';

  String? selectedNotificationPayload;

  //NotificationService a singleton object
  static final NotificationService _notificationService =
      NotificationService._internal();

  static void initialize(BuildContext? context) async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher_foreground"));

    flutterLocalNotificationsPlugin.initialize(initializationSettings,

        onSelectNotification: (String? route) async {
      if (route != null && context != null) {
        Map<String, dynamic> noteData = jsonDecode(route);
        String id = noteData.values.toString();

        if (noteData.containsKey('lessons')) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ItaliaLessonShow(
                    idLessons: id,
                  )));
        } else if (noteData.containsKey('libraries')) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => BookInitalScreen(

            idLib:id,
          )));
        } else if (noteData.containsKey('encyclopedias')) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => BookReadScreen(
                    encyId: id,
                  )));
        } else if (noteData.containsKey('audiolibraries')) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AudioLibraryDataShow(
                    adbId: id,
                   isFromNotifications: true,
                  )));
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      }
    }
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    tz.initializeTimeZones();
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const NotificationDetails notificationDetails = NotificationDetails(
      //  iOS: IOSNotificationDetails(subtitle:"Mashtoz",sound: "true"),
          android: AndroidNotificationDetails(
        'mashtoz',
        'mashtoz',
        icon:'@mipmap/ic_launcher',
        channelDescription: 'this is our channel',
        importance: Importance.high,
        priority: Priority.high,
      ));

      await flutterLocalNotificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['route'],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('data'),
      ),
    );
  }
}
