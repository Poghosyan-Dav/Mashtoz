import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:mashtoz_flutter/domens/repository/user_data_provider.dart';

class UserInfoNotify extends ChangeNotifier {
  final userDataProvider = UserDataProvider();

  int _userId = 0;
  String _userName = '';

  int get userId => _userId;
  String get userFullName => _userName;

  Future userData() async {
    userDataProvider.fetchUserInfo().then(
          (value) => inspect(value),
        );
    notifyListeners();
  }
}
