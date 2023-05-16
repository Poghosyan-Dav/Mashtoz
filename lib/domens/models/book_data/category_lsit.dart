class BookCategory {
  final String? categoryTitle;
  final String? title;
  final String? type;
  final int? id;

  BookCategory(
      {required this.categoryTitle,
      required this.id,
      required this.title,
      required this.type});

  factory BookCategory.fromJson(Map<String, dynamic> json) => BookCategory(
        categoryTitle: json['category_title'],
        id: json['id'],
        title: json['title'],
        type: json['type'],
      );
}
