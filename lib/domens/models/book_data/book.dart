import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'gallery_data.dart';

class Book {
  final int id;
  final String title;
  final String author;
  final String urlImage;

  const Book({
    required this.id,
    required this.author,
    required this.title,
    required this.urlImage,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'],
        author: json['author'],
        title: json['title'],
        urlImage: json['urlImage'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'urlImage': urlImage,
      };
}
// class Book {


class IalianLesson {
  final int id;
  final String title;
  final String image;
  final String number;
  final String link;
  IalianLesson({
    required this.id,
    required this.title,
    required this.image,
    required this.number,
    required this.link,
  });
}


class GalleryExampleItemThumbnail extends StatelessWidget {
  const GalleryExampleItemThumbnail({
    Key? key,
    required this.galleryExampleItem,
    required this.onTap,
  }) : super(key: key);

  final Gallery galleryExampleItem;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          
          tag: galleryExampleItem.id.toString(),
          child: CachedNetworkImage(imageUrl: galleryExampleItem.image!,height: 80,),
        ),
      ),
    );
  }
}
