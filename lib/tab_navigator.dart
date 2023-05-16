import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mashtoz_flutter/domens/data_providers/session_data_provider.dart';
import 'package:mashtoz_flutter/tab_provider.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/bottom_bars_pages/bottom_bar_menu_pages.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}


class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;
   bool isLogin = false;
  final _sessionProvider = SessionDataProvider();
  late final Map<String, WidgetBuilder> _routes;

  TabNavigator({
    required this.navigatorKey,
    required this.tabItem,
  }) {
    _routes = {
      'homepage': (context) => HomePage(),
      'librarypage': (context) => const LibraryPage(),
      'searchpage': (context) => const SearchPage(),
      'italianpage': (context) => ItalianPage(),
      'accountpage': (context) => FutureBuilder<Object>(
        future: AuthService().handleAuthState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return snapshot.data as Widget;
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final tabProvider = Provider.of<TabProvider>(context);
    if(isLogin)tabProvider.login();
    final routeBuilder = _routes[tabItem];
    if (routeBuilder == null) {
      return const SizedBox.shrink();
    }
    return Navigator(
      key: tabItem == 'accountpage' ? UniqueKey() : navigatorKey,
      onGenerateRoute: (routeSettings) => MaterialPageRoute(
        builder: routeBuilder,
      ),
    );
  }





  Future<bool> hasToken() async {
    String? token = await _sessionProvider.readsAccessToken();
    if (token != null) {
      // Check if the token has expired
      Map<String, dynamic> decodedToken = json.decode(
          ascii.decode(
              base64.decode(base64.normalize(token.split(".")[1]))
          )
      );
      if (DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000).isBefore(DateTime.now())) {
        // Token has expired, log the user out
        await _sessionProvider.deleteAllToken();
        return false;
      }
      // Token is valid, the user is logged in
      return true;
    }
    // Token not found, the user is not logged in
    return false;
  }
  Future<bool> checkUser() async {

    bool isSign = await hasToken();
    User? result = FirebaseAuth.instance.currentUser;
    isLogin = isSign;

    print("IsSign$isSign");
    return (result != null && isSign == true);
  }
}
