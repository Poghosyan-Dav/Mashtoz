class Gallery {
  Gallery({
    required this.id,
    required this.categoryId,
    required this.image,
    required this.images,
  });

  final int? id;
  final int? categoryId;
  final String? image;
  final List<Image>? images;

  factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
        id: json["id"] == null ? null : json["id"],
        categoryId: json["category_id"] == null ? null : json["category_id"],
        image: json["image"] == null ? null : json["image"],
        images: json["images"] == null
            ? null
            : List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );

  get resource => null;
}

class Image {
  Image({
    required this.img,
    required this.videoLink,
  });

  final String img;
  final dynamic videoLink;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        img: json["img"] == null ? null : json["img"],
        videoLink: json["video_link"] == null ? null : json["video_link"],
      );
}
