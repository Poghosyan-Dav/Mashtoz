import 'package:flutter/material.dart';

class BookNotifire extends ChangeNotifier {
  String _firstCharacterAudioLib = '';
  String   _firstCharacterDialect = '';

  String get firstCharactersDialect => _firstCharacterDialect;

  String get firstCharactersAudioLib => _firstCharacterAudioLib!;

  void charactersSetDialect(String dialcet) {
    _firstCharacterDialect = dialcet;
    notifyListeners();

  }

  void charactersSetAudioLib(var characters) {
    _firstCharacterAudioLib = characters;
    notifyListeners();
  }

  void resetDatas() {
    _firstCharacterAudioLib = '';
    _firstCharacterDialect = '';

  }
}
