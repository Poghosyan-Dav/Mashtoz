import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mashtoz_flutter/domens/data_providers/session_data_provider.dart';
import 'package:mashtoz_flutter/domens/repository/user_data_provider.dart';
import 'package:mashtoz_flutter/ui/widgets/helper_widgets/save_show_dialog.dart';

class TabProvider with ChangeNotifier {
  final _sessionProvider = SessionDataProvider();
  int _currentIndex = 0;
  BuildContext? _ctx ;
  bool _isUserLogin = false;
  Map<String, dynamic> _data = {};

  int get currentIndex => _currentIndex;
  bool get userHasLogin => _isUserLogin;

  void updateTabIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
  void updateSaveData(  Map<String, dynamic>  data,BuildContext context) {
    _data = data ;
    _ctx = context;
    notifyListeners();
  }

  Future<void> userIsSign() async {

    await   UserDataProvider().fetchUserInfo().then((value) {
      _data['customer_id'] = value?.id;
    }).then((value) {
      if(_data.isNotEmpty){
          showDialog(
            context: _ctx!,
            barrierDismissible: false,
            builder: (context) => SaveShowDialog(
              data: _data,
              isShow: false,
            ),
          );
        }
    });




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
    print("IsSign$isSign");
    if(result != null || isSign){
      return true;
    }else{
      return false;
    }

  }
  void login() {
    _isUserLogin  = true;
    notifyListeners();
  }

  void logout() {
    _isUserLogin  = false;
    notifyListeners();
  }  }
