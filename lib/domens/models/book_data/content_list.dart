class Content {
  final int? id;
  final String? title;
  final String? image;
  final String? body;
  final String? videoLink;
  final String? link;
  final String? explanation;
  final String? author;
  final String? number;
  final String? summary;
  final String? first_character;
  final String? sharurl;

  final Map<String, Content>? content;

  Content({
    this.id,
    this.title,
    this.image,
    this.body,
    this.videoLink,
    this.link,
    this.explanation,
    this.author,
    this.number,
    this.summary,
    this.first_character,
    this.sharurl,
    this.content,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    body: json["body"],
    videoLink: json["video_link"],
    link: json["link"],
    explanation: json["explanation"],
    author: json["author"],
    number: json['number'],
    first_character: json['first_character'],
    summary: json['summary'],
    sharurl: json['sharurl'],
    content: json['content'] == null
        ? {}
        : Map<String, dynamic>.from(json['content'])
        .map((key, value) => MapEntry(key, Content.fromJson(value))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "body": body,
    "video_link": videoLink,
    "link": link,
    "explanation": explanation,
    "author": author,
    "number": number,
    "first_character": first_character,
    "summary": summary,
    "sharurl": sharurl,
    "content": content == null
        ? null
        : Map.from(content!)
        .map((key, value) => MapEntry(key, value.toJson())),
  };
}

class UserAccount {
  final String? type;
  final String? type_id;
  final dynamic content;

  const UserAccount({
    required this.content,
    required this.type,
    required this.type_id,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      type: json['type'],
      type_id: json['type_id'],
      content: json['content'] != null ? Content.fromJson(json['content']) : null,
    );
  }

}
