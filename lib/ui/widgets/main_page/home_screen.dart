import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mashtoz_flutter/config/palette.dart';
import 'package:mashtoz_flutter/domens/data_providers/session_data_provider.dart';
import 'package:mashtoz_flutter/tab_navigator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domens/blocs/update_home_bloc.dart';
import '../../../domens/blocs/update_home_event.dart';
import '../../../domens/repository/book_data_provdier.dart';
import '../../../tab_provider.dart';
import '../notifications/notification_service.dart';
import 'library_pages/book_page.dart';
import 'library_pages/book_read_screen.dart';

enum BottomIcons {
  home,
  library,
  search,
  italian,
  account,
  initall,
}

enum ScreenName {
  books,
  book,
  bookRead,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // static BottomIcons? icons = BottomIcons.home;
  final _sessionProvider = SessionDataProvider();
  final _bookDataProvider = BookDataProvider();
  bool isLogin = false;

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat", navigate to a chat screen
    if (initialMessage != null) {

      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    await onHandlePushNotification(context: context, message: message);
  }
  Future<void> _loadPushMessages() async {

    final prefs = await SharedPreferences.getInstance();
    final messagesKey = 'push_messages';
    Map<String, dynamic> noteData = {};
    final savedMessages = prefs.getStringList(messagesKey);
    if(savedMessages != null) await prefs.remove(messagesKey);
    print('savedMessages $savedMessages');
    if (savedMessages != null && savedMessages.isNotEmpty) {
      print('savedMessages $savedMessages');
      final MyBloc bloc = BlocProvider.of<MyBloc>(context);
      bloc.add(const UpdateScreenEvent(true));
      for (String jsonString in savedMessages) {
        try {
          noteData = jsonDecode(jsonString);
          print('noteData $noteData');
        } catch (e) {
          print('Error decoding JSON: $e');
        }
      }
      Future.delayed(const Duration(milliseconds: 700), () {
        if (noteData.containsKey('libraries') &&
            noteData['libraries'].toString().isNotEmpty) {
          print(
              'noteData libraries : ${noteData["libraries"]} : ${noteData["categoryID"]}');
          var librariesId = noteData['libraries'].toString();
          var cateroyId = noteData['categoryID'].toString();

          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => BookInitalScreen(
                idLib: librariesId,
                categoryID: cateroyId,
              )));
        } else if (noteData.containsKey('libraries') &&
            noteData['subld'].toString().isNotEmpty != null) {
          var subID = noteData["subld"].toString();
          var cateroyId = noteData["categoryID"].toString();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => BookReadScreen(
                idLib: subID,
                categoryId: cateroyId,
              )));
        } else if (noteData.containsKey('encyclopedias')) {
          var encyclopediasId = noteData["encyclopedias"].toString();
          var character = noteData["character"].toString();
          print('noteData encyclopedias : $encyclopediasId $character');

          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => BookReadScreen(
                encyId: encyclopediasId,
                character: character,
              )));
        } else if (noteData.containsKey('audiolibraries')) {
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (_) => AudioLibraryDataShow(
          //       adbId: noteData['audiolibraries'] ,
          //       isFromNotifications: true,
          //     )));
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      });
    } else {
      // Handle the case where savedMessages is empty or null
      print('No messages found in SharedPreferences');
    }

  }

  Future<void> onHandlePushNotification(
      {required BuildContext context, required RemoteMessage message}) async {
    if (message.data['route'] != null && context != null) {
      final MyBloc bloc = BlocProvider.of<MyBloc>(context);
      bloc.add(const UpdateScreenEvent(true));
      Map<String, dynamic> noteData = jsonDecode(message.data['route']);
      //   if (noteData.containsKey('lessons')) {
      //   Navigator.of(context).push(MaterialPageRoute(
      //       builder: (_) =>
      //           ItaliaLessonShow(
      //             idLessons:noteData['lessons'],
      //           )));
      // }
      if (noteData.containsKey('libraries') &&
          noteData['libraries'].toString().isNotEmpty) {
        print(
            'noteData libraries : ${noteData["libraries"]} : ${noteData["categoryID"]}');
        var librariesId = noteData["libraries"].toString();
        var cateroyId = noteData["categoryID"].toString();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => BookInitalScreen(
                  idLib: librariesId,
                  categoryID: cateroyId,
                )));
      } else if (noteData.containsKey('libraries') &&
          noteData['subld'].toString().isNotEmpty != null) {
        var subID = noteData["subld"].toString();
        var cateroyId = noteData["categoryID"].toString();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => BookReadScreen(
                  idLib: subID,
                  categoryId: cateroyId,
                )));
      } else if (noteData.containsKey('encyclopedias')) {
        var encyclopediasId = noteData["encyclopedias"].toString();
        var character = noteData["character"].toString();
        print('noteData encyclopedias : $encyclopediasId $character');

        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => BookReadScreen(
                  encyId: encyclopediasId,
                  character: character,
                )));
      } else if (noteData.containsKey('audiolibraries')) {
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (_) => AudioLibraryDataShow(
        //       adbId: noteData['audiolibraries'] ,
        //       isFromNotifications: true,
        //     )));
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    }
  }

  @override
  void initState() {
    setupInteractedMessage();
    _loadPushMessages();
    NotificationService.initialize(context);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data["route"];

        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });
    FirebaseMessaging.onMessage.listen((message) async{
      print('zxcv');
      if (message.data['route'] != null) {
        final prefs = await SharedPreferences.getInstance();

        final messagesKey = 'push_messages';


        List<String>? savedMessages = prefs.getStringList(messagesKey);

        if(savedMessages != null) await prefs.remove(messagesKey);

        savedMessages ??= [];

        savedMessages.add(message.data['route'].toString()); // You can customize how you save the message data here

        await prefs.setStringList(messagesKey, savedMessages);
        _loadPushMessages();
        print('Route${message.data['route']}');

        print(message.notification!.body);
        print(message.notification!.title);
      }
      print("Received a message: ${message.notification?.title}");


      NotificationService.display(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final MyBloc bloc = BlocProvider.of<MyBloc>(context);
      final routeFromMessage = message.data["route"];

      if (routeFromMessage != null) {
        bloc.add(const UpdateScreenEvent(true));

        Map<String, dynamic> noteData = jsonDecode(routeFromMessage);
        //   if (noteData.containsKey('lessons')) {
        //   Navigator.of(context).push(MaterialPageRoute(
        //       builder: (_) =>
        //           ItaliaLessonShow(
        //             idLessons:noteData['lessons'],
        //           )));
        // }
        CustomToast.show(context, 'message', () {
          if (noteData.containsKey('libraries') &&
              noteData['libraries'].toString().isNotEmpty) {
            print(
                'noteData libraries : ${noteData["libraries"]} : ${noteData["categoryID"]}');
            var librariesId = noteData["libraries"].toString();
            var cateroyId = noteData["categoryID"].toString();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BookInitalScreen(
                      idLib: librariesId,
                      categoryID: cateroyId,
                    )));
          } else if (noteData.containsKey('libraries') &&
              noteData['subld'].toString().isNotEmpty != null) {
            var subID = noteData["subld"].toString();
            var cateroyId = noteData["categoryID"].toString();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BookReadScreen(
                      idLib: subID,
                      categoryId: cateroyId,
                    )));
          } else if (noteData.containsKey('encyclopedias')) {
            var encyclopediasId = noteData["encyclopedias"].toString();
            var character = noteData["character"].toString();
            print('noteData encyclopedias : $encyclopediasId $character');

            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BookReadScreen(
                      encyId: encyclopediasId,
                      character: character,
                    )));
          } else if (noteData.containsKey('audiolibraries')) {
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (_) => AudioLibraryDataShow(
            //       adbId: noteData['audiolibraries'] ,
            //       isFromNotifications: true,
            //     )));
          } else {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const HomeScreen()));
          }
        });
      }
    });
    hasToken();
    super.initState();
  }

  Future<void> hasToken() async {
    String? hasToken = await _sessionProvider.readsAccessToken();
    if (hasToken != null) {
      Provider.of<TabProvider>(context, listen: false).login();
    }
  }

  final List<String> _tabItems = [
    'homepage',
    'librarypage',
    'searchpage',
    'italianpage',
    'accountpage'
  ];
  int _currentIndex = 0;
  int _previousIndex = 0;
  int _newIndex = 0;
  // Create a GlobalKey for each TabNavigator instance
  final GlobalKey<NavigatorState> _homeNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _libraryNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _searchNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _italianNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> accountNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final tabProvider = Provider.of<TabProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        // Check if there's a previous page to pop on the current tab's Navigator
        if (_homeNavigatorKey.currentState!.canPop()) {
          _homeNavigatorKey.currentState!.pop();
        } else {
          // Check if we're at the first tab and there's no previous tab to switch to
          if (_currentIndex == 0) {
            // If so, let the system handle the back button press
            return true;
          } else {
            // Check if the new tab is the same as the current tab
            if (_previousIndex == _currentIndex) {
              // If so, let the system handle the back button press
              return true;
            } else {
              // Otherwise, switch to the new tab
              setState(() {
                _previousIndex = _currentIndex;
                _currentIndex = _newIndex;
              });
            }
          }
        }
        return false;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            // Use the TabNavigator widget for each tab
            TabNavigator(
                navigatorKey: _homeNavigatorKey, tabItem: _tabItems[0]),
            TabNavigator(
                navigatorKey: _libraryNavigatorKey, tabItem: _tabItems[1]),
            TabNavigator(
                navigatorKey: _searchNavigatorKey, tabItem: _tabItems[2]),
            TabNavigator(
                navigatorKey: _italianNavigatorKey, tabItem: _tabItems[3]),
            TabNavigator(
                navigatorKey: accountNavigatorKey, tabItem: _tabItems[4]),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Palette.main,
          fixedColor: Palette.cursor,
          currentIndex: _currentIndex,
          elevation: 0.0,
          onTap: (int index) {
            setState(() => _currentIndex = index);
            tabProvider.updateTabIndex(index);
          },
          items: [
            BottomNavigationBarItem(
              backgroundColor: Palette.barColor,
              icon: SvgPicture.asset(
                'assets/images/home.svg',
                width: 25,
                height: 30,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: Palette.barColor,
              icon: SvgPicture.asset(
                'assets/images/library.svg',
                width: 25,
                height: 30,
              ),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              backgroundColor: Palette.barColor,
              icon: SvgPicture.asset(
                'assets/images/search2.svg',
                width: 25,
                height: 27,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              backgroundColor: Palette.barColor,
              icon: SvgPicture.asset(
                'assets/images/italian_lessons.svg',
                width: 25,
                height: 27,
              ),
              label: 'Italian',
            ),
            BottomNavigationBarItem(
              backgroundColor: Palette.barColor,
              icon: SvgPicture.asset(
                'assets/images/profile.svg',
                width: 25,
                height: 27,
              ),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}

class CustomToast {
  static void show(BuildContext context, String message, Function onTap) {
    OverlayEntry? entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width,
        child: Material(
          color: Colors.transparent,
          child: Container(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                onTap();
                entry?.remove();
              },
              child: Card(
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(entry);
  }
}
