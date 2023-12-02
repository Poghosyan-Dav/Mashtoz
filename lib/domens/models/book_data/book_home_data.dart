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
  Map<String, dynamic>? encyclopedias; // Updated to use a Map
  String? audiolibraries;
  List<String>? dialects;

  factory HomeData.fromJson(Map<dynamic, dynamic> json) {
    return HomeData(
      libraries: Content.fromJson(json["libraries"]),
      lessons: List<Lessons>.from(json["lessons"].map((x) => Lessons.fromJson(x))),
      encyclopedias: Map<String, dynamic>.from(json["encyclopedias"]),
      audiolibraries: json["audiolibraries"],
      dialects: List<String>.from(json["dialects"].map((x) => x)),
    );
  }

  // Get value from encyclopedias using a key
  String? getEncyclopediaValue(String key) {
    return encyclopedias?[key];
  }
}
