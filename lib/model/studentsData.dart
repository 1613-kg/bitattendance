class StudentsData {
  String id;
  String rollNo;
  String name;
  Map<String, bool> isPresent;

  StudentsData(
      {required this.id,
      required this.name,
      required this.rollNo,
      required this.isPresent});
}
