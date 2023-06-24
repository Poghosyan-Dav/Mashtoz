import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mashtoz_flutter/domens/blocs/Login/login_bloc.dart';
import 'package:mashtoz_flutter/domens/blocs/register_bloc/register_bloc.dart';
import 'package:mashtoz_flutter/domens/models/app_theme.dart/theme_notifire.dart';
import 'package:mashtoz_flutter/domens/models/bottom_bar_color_notifire.dart';
import 'package:mashtoz_flutter/domens/models/user_sign_or_not.dart';
import 'package:mashtoz_flutter/domens/repository/user_data_provider.dart';
import 'package:mashtoz_flutter/firebase_options.dart';
import 'package:mashtoz_flutter/tab_provider.dart';
import 'package:mashtoz_flutter/ui/utils/day_change_notifire.dart';
import 'package:mashtoz_flutter/ui/utils/splash_screen.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/library_pages/book_inherited_widget.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:provider/provider.dart';

import 'domens/models/book_data/book_channgeNotifire.dart';
import 'ui/utils/log_out_changenotifire.dart';

bool isWhichPlatform = false;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('A bg message just showed up :  ${message.messageId}');
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 //  await Hive.initFlutter();
 // Hive.registerAdapter(ContentAdapter());
 // Hive.registerAdapter(DataAdapter());
 // Hive.registerAdapter(HomeDataAdapter());
 // Hive.registerAdapter(LessonsAdapter());


 Platform.isIOS ? isWhichPlatform = true : isWhichPlatform;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
 // await Future.wait([
 //   Hive.openBox('data'),
 //   Hive.openBox('UserData'),
 //   Hive.openBox('category'),
 // ]);
 await initializeDateFormatting();

  runApp(const MyApp());
  CacheManager.logLevel = CacheManagerLogLevel.verbose;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? _deviceId;
  final _userDataProvider = UserDataProvider();
  Future<void> initPlatformState() async {
    String? deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
      print("deviceId->$_deviceId");
    });
  }
  @override
  void initState() {
    super.initState();
    initPlatformState();
    getToken();
  }
  void getToken() async {

    String? token = await messaging.getToken();

    if (token != null && _deviceId != null) {
      var data = {'device_id': _deviceId, 'fcm_token': token};
      print("device_id : ${data['device_id']} &\nfcm_token: ${data['fcm_token']}");
      _userDataProvider.postFCMToken(data);
    }

    messaging.onTokenRefresh.listen((newToken) {
      if (newToken != null && _deviceId != null) {
        var data = {'device_id': _deviceId, 'fcm_token': token};
        print("device_id : ${data['device_id']} &\nfcm_token: ${data['fcm_token']}");
        _userDataProvider.postFCMToken(data);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final user = UserDataProvider();
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (_) => LoginCubit(user)),
        BlocProvider<RegisterCubit>(create: (_) => RegisterCubit(user)),
      ],
      child: MultiProvider(
        providers: [
          Provider<UserDataProvider>(
            create: (_) => UserDataProvider(auth: FirebaseAuth.instance),
          ),
          ChangeNotifierProvider<UserLogOutNotifier>(create: (_)=> UserLogOutNotifier(),),

          ChangeNotifierProvider<ContentProvider>(
              create: (_) => ContentProvider()),
          ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier()),
          ChangeNotifierProvider<UserInfoNotify>(
              create: (_) => UserInfoNotify()),
          ChangeNotifierProvider<BottomColorNotifire>(
              create: (_) => BottomColorNotifire()),
          ChangeNotifierProvider<BookNotifire>.value(value:  BookNotifire()),
          ChangeNotifierProvider<BookNotifire>.value(value:  BookNotifire()),
          ChangeNotifierProvider<FocuseDay>(create: (_) => FocuseDay()),
          ChangeNotifierProvider<TabProvider>(
    create: (_) => TabProvider(),)
        ],
        child: MaterialApp(
          locale: _locale,
          debugShowCheckedModeBanner: false,
          home: // Boxes have finished opening, so render the app UI
                 const MySplashScreen(),



        ),
      ),
    );
  }
}
