import 'package:mashtoz_flutter/domens/models/book_data/content_list.dart';
import 'package:mashtoz_flutter/domens/models/book_data/lessons.dart';

class HomeData {
  HomeData({
    this.libraries,
    this.lessons,
    this.encyclopedias,
    this.audiolibraries,
    this.dialects,
  });

  Content? libraries;
  List<Lessons>? lessons;
  List<String>? encyclopedias;
  String? audiolibraries;
  List<String>? dialects;

  factory HomeData.fromJson(Map<dynamic, dynamic> json) => HomeData(
    libraries: Content.fromJson(json["libraries"]),
    lessons:
    List<Lessons>.from(json["lessons"].map((x) => Lessons.fromJson(x))),
    encyclopedias: List<String>.from(json["encyclopedias"].map((x) => x)),
    audiolibraries: json["audiolibraries"],
    dialects: List<String>.from(json["dialects"].map((x) => x)),
  );
}
