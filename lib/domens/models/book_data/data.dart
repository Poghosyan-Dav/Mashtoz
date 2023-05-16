class Data {
  Data({
    this.id,
    this.image,
    this.title,
    this.body,
    this.type,
    this.explanation,
    this.firstCharacter,
    this.link,
    this.summary,
    this.video_link,
    this.sharurl,
    this.author
  });

  final int? id;
  final String? image;
  final String? title;
  final String? body;
  final String? type;
  final String? author;
  final dynamic link;
  final String? video_link;
  final String? firstCharacter;
  final String? explanation;
  final String? summary;
  final String? sharurl;
  factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
        id: json["id"] == null ? null : json["id"],
        image: json["image"] == null ? null : json["image"],
        title: json["title"] == null ? null : json["title"],
        type: json["type"] == null ? null : json["type"],
    author: json["author"] == null ? null : json["author"],

    body: json["body"] == null ? null : json["body"],
        summary: json["summary"] == null ? null : json["summary"],
        link: json["link"] == null ? null : json["link"],
        firstCharacter:
            json["first_character"] == null ? null : json["first_character"],
        explanation: json["explanation"] == null ? null : json["explanation"],
        video_link: json["video_link"] == null ? null : json["video_link"],
        sharurl: json['sharurl'] == null ? null : json['sharurl'],
      );
}
