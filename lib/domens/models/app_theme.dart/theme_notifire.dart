import 'package:flutter/material.dart';
import 'package:mashtoz_flutter/config/palette.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData? _themeData;

  get theme => _themeData;
  get backgroundColor => _themeData?.dialogBackgroundColor;
  get textMainColor => _themeData?.iconTheme;
  get primariColor => _themeData?.primaryColor;
  get readBookBackgroundColor => _themeData?.backgroundColor;
  get lightTheme => ThemeData();
  void lightThemeData() {
    _themeData = ThemeData().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Color.fromRGBO(122, 108, 115, 1),
            ),
        primaryColor: Palette.textLineOrBackGroundColor,
        backgroundColor: Color.fromRGBO(226, 225, 224, 1),
        dialogBackgroundColor: Palette.textLineOrBackGroundColor);

    notifyListeners();
  }

  void darkThemeData() {
    _themeData = ThemeData().copyWith(
      dialogBackgroundColor: Color.fromRGBO(51, 51, 51, 1),
      textTheme: ThemeData.dark().textTheme.apply(
            bodyColor: Color.fromRGBO(189, 189, 189, 1),
          ),
      backgroundColor: Color.fromRGBO(31, 31, 31, 0.5),
    );

    notifyListeners();
  }
}
