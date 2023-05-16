import 'package:flutter/material.dart';
import 'package:mashtoz_flutter/domens/models/book_data/content_list.dart';
import 'package:mashtoz_flutter/domens/repository/book_data_provdier.dart';

class ContentProvider extends ChangeNotifier {
  final bookDataProvider = BookDataProvider();
  Content? _content;
  String? _author;
  String? _title;
  int? _pageIndex;
  Content? get bookContents => _content;

  String? get bookAuthor => _author;

  String? get booktitle => _title;
  int? get pageIndex => _pageIndex;
  void getContentList(Content content) async {
    _content = await content;
    notifyListeners();
  }

  void setBookAuthor_Titile({String? author, String? title}) {
    _author = author;
    _title = title;
    notifyListeners();
  }

  void setPageIndex({int? index}) {
    _pageIndex = index;
    notifyListeners();
  }
}
