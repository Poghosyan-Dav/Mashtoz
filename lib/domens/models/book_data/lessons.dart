class Lessons {
  Lessons({
    required this.id,
    required this.image,
    required this.title,
    required this.link,
    required this.number,
  });

  final int? id;
  final String? image;
  final String? title;
  final String? link;
  final String? number;

  factory Lessons.fromJson(Map<dynamic, dynamic> json) => Lessons(
        id: json["id"] == null ? null : json["id"],
        image: json["image"] == null ? null : json["image"],
        title: json["title"] == null ? null : json["title"],
        link: json["link"] == null ? null : json["link"],
        number: json["number"] == null ? null : json["number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "image": image == null ? null : image,
        "title": title == null ? null : title,
        "link": link == null ? null : link,
        "number": number == null ? null : number,
      };
}
