import 'dart:convert';



Search searchFromMap(String str) => Search.fromJson(json.decode(str));

// String searchToMap(Search data) => json.encode(data.toMap());

class Search {
  int? id;
  String? title;
  String? image;
  String? type;

  Search({
    this.id,
    this.title,
    this.image,
    this.type,
  });

  factory Search.fromJson(Map<String, dynamic> json) => Search(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        type: json['type'],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "image": image,
        "type": type == null ? null : type,
      };
}
