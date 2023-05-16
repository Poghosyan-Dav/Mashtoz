import 'package:flutter/material.dart';
import 'package:mashtoz_flutter/domens/models/book_data/word_of_day.dart';
import 'package:mashtoz_flutter/domens/repository/book_data_provdier.dart';

class FocuseDay extends ChangeNotifier {
  final bookDataProvider = BookDataProvider();

  var _focusDays = DateTime.now().day.toInt();
  var _focuseDate = DateTime.now().toString();
  var _focusDayText = '';
  var _focusDayAuthor = '';
  var _date = DateTime.now();
  int get day => _focusDays;
  DateTime get myDate =>_date;
  String get wordsDate => _focuseDate;

  String get summaryText => _focusDayText;

  String get authorText => _focusDayAuthor;

  void setDays(int days,DateTime date) {
    _focusDays = days;
   _date = date;
    notifyListeners();
  }

  // void setTextOfDay({required String author, required String summary}) {
  //   _focusDayText = summary;
  //   _focusDayAuthor = author;
  // }

  void setWordsDate(String? date) {
    //2022-04-21
    _focuseDate = date ?? '';
   // getDataByDate();
    notifyListeners();
  }

  Future<WordOfDay> getData() async =>
      bookDataProvider.getWordsOfDay().then((value) {
        _focusDayAuthor = value!.author!;
        _focusDayText = value.summary!;
        return value;
      });
  // Future<WordOfDay> getDataByDate() async {
  //   return bookDataProvider.getWordsOfDayByDate(_focuseDate).then((value) {
  //     _focusDayAuthor = value!.author!;
  //     _focusDayText = value.summary!;
  //     return value;
  //   });
  //
  // }
}


