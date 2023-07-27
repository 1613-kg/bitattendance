class BlogData {
  String blogId;
  String title;
  String label;
  String description;
  DateTime date;
  String addedBy;
  List<String> images;

  BlogData(
      {required this.blogId,
      required this.date,
      required this.description,
      required this.label,
      required this.title,
      required this.addedBy,
      required this.images});
}
