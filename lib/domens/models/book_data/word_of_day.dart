import 'dart:convert';

WordOfDay wordOfDayFromJson(String str) => WordOfDay.fromJson(json.decode(str));

class WordOfDay {
  WordOfDay({
    this.summary,
    this.author,
  });

  final String? summary;
  final String? author;

  factory WordOfDay.fromJson(Map<String, dynamic> json) => WordOfDay(
        summary: json["summary"] == null ? null : json["summary"],
        author: json["author"] == null ? null : json["author"],
      );
}
