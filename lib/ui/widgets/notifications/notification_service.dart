import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/home_screen.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/library_pages/book_page.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/library_pages/book_read_screen.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../../../domens/blocs/update_home_bloc.dart';
import '../../../domens/blocs/update_home_event.dart';
import '../../../firebase_options.dart';

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message,) async {
  print(' --- background message received ---');
  print(message.notification!.title);
  print('im here fuck');
  // Setting the context
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // const InitializationSettings initializationSettings =
  // InitializationSettings(
  //     android: AndroidInitializationSettings("@mipmap/ic_launcher_foreground"));
  // final notification = FlutterLocalNotificationsPlugin();
  // await notification.show(
  //   0,
  //   message.notification!.title ?? 'Notification',
  //   message.notification!.body ?? '',
  //   const NotificationDetails(
  //     android: AndroidNotificationDetails(
  //       'mashtoz',
  //       'mashtoz',
  //
  //       priority: Priority.high,
  //       importance: Importance.max,
  //     ),
  //   ),
  //   payload: message.data['route'], // Example payload
  // );
// Accessing the context

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
        final MyBloc bloc = BlocProvider.of<MyBloc>(context);
        bloc.add(const UpdateScreenEvent(true));
        Map<String, dynamic> noteData = jsonDecode(route);
        //   if (noteData.containsKey('lessons')) {
        //   Navigator.of(context).push(MaterialPageRoute(
        //       builder: (_) =>
        //           ItaliaLessonShow(
        //             idLessons:noteData['lessons'],
        //           )));
        // }
        if (noteData.containsKey('libraries') &&  noteData['libraries'].toString().isNotEmpty) {
          print('noteData libraries : ${noteData["libraries"]} : ${noteData["categoryID"]}');
          var librariesId =     noteData["libraries"].toString();
          var cateroyId = noteData["categoryID"].toString();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) =>
              BookInitalScreen(
                idLib: librariesId,
                categoryID:cateroyId,
              )));
        }
        else if (noteData.containsKey('libraries') &&  noteData['subld'].toString().isNotEmpty != null) {
          var subID =     noteData["subld"].toString();
          var cateroyId = noteData["categoryID"].toString();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) =>
                  BookReadScreen(
                    idLib: subID,
                    categoryId: cateroyId,
                  )));
        }
        else if (noteData.containsKey('encyclopedias')) {
          var encyclopediasId =     noteData["encyclopedias"].toString();
          var character = noteData["character"].toString();
          print('noteData encyclopedias : $encyclopediasId $character');

          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) =>
                  BookReadScreen(
                    encyId: encyclopediasId,
                    character: character,
                  )));
        }
        else if (noteData.containsKey('audiolibraries')) {
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (_) => AudioLibraryDataShow(
          //       adbId: noteData['audiolibraries'] ,
          //       isFromNotifications: true,
          //     )));
        }
        else {
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
        icon:'@mipmap/ic_launcher_foreground',
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


