import 'package:flutter/material.dart';

class BottomColorNotifire extends ChangeNotifier {
  Color? _color = Colors.transparent;

  Color get barColor => _color!;

  void setColor(Color color) {
    _color = color;
    notifyListeners();
  }
}
