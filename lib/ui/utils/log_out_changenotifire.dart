import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mashtoz_flutter/auth_service.dart';
import 'package:mashtoz_flutter/domens/data_providers/session_data_provider.dart';

import '../widgets/main_page/home_screen.dart';

class UserLogOutNotifier extends ChangeNotifier{
  bool _logOut =  false;
  bool _isSign = false;
  final sessionDataProvider = SessionDataProvider();

  String _name = '' ;
  bool get userLogOut => _logOut;
  bool get userSign => _isSign;

  String get userName => _name;

  Future<void> usesHasLogOut(bool isLogOut)async{
    _logOut = true;
   await AuthService().signOut();
   await sessionDataProvider
        .deleteAllToken();
    notifyListeners();

    Future.delayed(const Duration(seconds: 1),(){
      _logOut = false;
      _name = '';
      notifyListeners();

    }).whenComplete(() {

      Fluttertoast.showToast(msg: 'Logging Out',
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }
  Future<void> userSignWigGoogle(bool isSign,BuildContext context)async{
    _logOut = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 1500),(){
      _logOut = false;
      notifyListeners();

    }).whenComplete(() {

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(
          ),
        ),
      );
    });
  }
  void saveUserName (){
    User? user = FirebaseAuth.instance.currentUser;
    List<String>? username = user?.displayName?.split(' ');

    if(username!=null){
      _name = username[0] + " " + username[1].substring(0,1) + ".";

    }else{
      _name = '';
    }
  }
  void makeLoading(){
    _logOut = true;
    notifyListeners();
  }
}